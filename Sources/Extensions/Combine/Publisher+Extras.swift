// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

// MARK: - replaceErrorWithEmpty

public extension Publisher {
    /// Swallow errors and return an empty publisher.
    func replaceErrorWithEmpty() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty<Output, Never>() }
            .eraseToAnyPublisher()
    }
}

// MARK: - mapToVoid

public extension Publisher {
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        map { _ in () }.eraseToAnyPublisher()
    }
}

// MARK: - filterNil

public extension Publisher {
    func filterNil<Wrapped>() -> AnyPublisher<Wrapped, Failure> where Output == Wrapped? {
        compactMap { $0 }.eraseToAnyPublisher()
    }
}

// MARK: - orEmpty (String? → String)

public extension Publisher where Output == String? {
    var orEmpty: AnyPublisher<String, Failure> {
        map { $0 ?? "" }.eraseToAnyPublisher()
    }
}

public extension AnyPublisher where Output == String?, Failure == Never {
    var orEmpty: AnyPublisher<String, Never> {
        map { $0 ?? "" }.eraseToAnyPublisher()
    }
}

// MARK: - flatMapLatest

public extension Publisher where Failure == Never {
    /// Map to a new publisher and switch to the latest — cancels the previous inner publisher on a new value.
    func flatMapLatest<P: Publisher>(
        _ transform: @escaping (Output) -> P
    ) -> AnyPublisher<P.Output, Never> where P.Failure == Never {
        map(transform)
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func flatMapLatest<P: Publisher>(
        _ transform: @escaping (Output) -> P
    ) -> AnyPublisher<P.Output, P.Failure> where P.Failure == Failure {
        map(transform)
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

// MARK: - withLatestFrom

public extension Publisher where Failure == Never {
    func withLatestFrom<Other: Publisher>(
        _ other: Other
    ) -> AnyPublisher<Other.Output, Never> where Other.Failure == Never {
        withLatestFrom(other) { $1 }
    }

    func withLatestFrom<Other: Publisher, Result>(
        _ other: Other,
        resultSelector: @escaping (Output, Other.Output) -> Result
    ) -> AnyPublisher<Result, Never> where Other.Failure == Never {
        WithLatestFromPublisher(upstream: self, other: other, resultSelector: resultSelector)
            .eraseToAnyPublisher()
    }
}

// Custom publisher for withLatestFrom
private struct WithLatestFromPublisher<
    Upstream: Publisher,
    Other: Publisher,
    Result
>: Publisher where Upstream.Failure == Never, Other.Failure == Never {
    typealias Output = Result
    typealias Failure = Never

    let upstream: Upstream
    let other: Other
    let resultSelector: (Upstream.Output, Other.Output) -> Result

    func receive<S: Subscriber>(subscriber: S)
        where S.Input == Result, S.Failure == Never {
        let subscription = Inner(
            downstream: subscriber,
            other: other,
            resultSelector: resultSelector
        )
        subscriber.receive(subscription: subscription)
        upstream.subscribe(subscription)
    }

    private final class Inner<Downstream: Subscriber>: Subscription, Subscriber
    where Downstream.Input == Result, Downstream.Failure == Never {
        typealias Input = Upstream.Output
        typealias Failure = Never

        private var downstream: Downstream?
        private var upstreamSubscription: Subscription?
        private var otherCancellable: AnyCancellable?
        private var latestOther: Other.Output?
        private var pendingDemand: Subscribers.Demand = .none
        private let resultSelector: (Upstream.Output, Other.Output) -> Result

        init(
            downstream: Downstream,
            other: Other,
            resultSelector: @escaping (Upstream.Output, Other.Output) -> Result
        ) {
            self.downstream = downstream
            self.resultSelector = resultSelector
            self.otherCancellable = other.sink { [weak self] value in
                self?.latestOther = value
            }
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else { return }
            pendingDemand += demand
            upstreamSubscription?.request(demand)
        }

        func cancel() {
            upstreamSubscription?.cancel()
            upstreamSubscription = nil
            otherCancellable?.cancel()
            otherCancellable = nil
            downstream = nil
            latestOther = nil
            pendingDemand = .none
        }

        func receive(subscription: Subscription) {
            upstreamSubscription = subscription
            if pendingDemand > .none {
                subscription.request(pendingDemand)
            }
        }

        func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            guard
                let latestOther,
                let downstream
            else {
                return .none
            }
            return downstream.receive(resultSelector(input, latestOther))
        }

        func receive(completion: Subscribers.Completion<Never>) {
            downstream?.receive(completion: completion)
            cancel()
        }
    }
}

// MARK: - ifEmpty(switchTo:)

public extension Publisher where Failure == Never {
    func ifEmpty(switchTo replacement: AnyPublisher<Output, Never>) -> AnyPublisher<Output, Never> {
        var didEmit = false
        return handleEvents(receiveOutput: { _ in didEmit = true })
            .append(
                Deferred {
                    didEmit ? AnyPublisher<Output, Never>.empty() : replacement
                }
            )
            .eraseToAnyPublisher()
    }
}
