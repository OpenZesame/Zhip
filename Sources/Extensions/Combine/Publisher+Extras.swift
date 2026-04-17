// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

// MARK: - asDriver / asDriverOnErrorReturnEmpty

public extension Publisher where Failure == Never {
    /// Identity – already a Driver (AnyPublisher<T, Never>).
    func asDriver() -> AnyPublisher<Output, Never> {
        eraseToAnyPublisher()
    }

    /// Identity – no errors to catch.
    func asDriverOnErrorReturnEmpty() -> AnyPublisher<Output, Never> {
        eraseToAnyPublisher()
    }
}

public extension Publisher {
    /// Swallow errors and return an empty Driver.
    func asDriverOnErrorReturnEmpty() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty<Output, Never>() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func catchErrorReturnEmpty() -> AnyPublisher<Output, Never> {
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
    /// Equivalent to RxSwift's flatMapLatest – cancels previous inner publisher when a new one starts.
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
        let storage = WithLatestFromStorage<Other.Output>()

        var otherCancellable: AnyCancellable?
        otherCancellable = other.sink { [weak storage] value in
            storage?.latest = value
            _ = otherCancellable // keep alive
        }
        storage.otherCancellable = otherCancellable

        upstream
            .compactMap { [weak storage] upstreamValue -> Result? in
                guard let latestOther = storage?.latest else { return nil }
                return resultSelector(upstreamValue, latestOther)
            }
            .receive(subscriber: subscriber)
    }
}

private final class WithLatestFromStorage<T> {
    var latest: T?
    var otherCancellable: AnyCancellable?
}

// MARK: - .drive() shim — subscribe and discard values

public extension AnyPublisher where Failure == Never {
    @discardableResult
    func drive() -> AnyCancellable {
        sink(receiveValue: { _ in })
    }
}

// MARK: - .do(onNext:) shim

public extension Publisher where Failure == Never {
    func `do`(onNext: @escaping (Output) -> Void) -> AnyPublisher<Output, Never> {
        handleEvents(receiveOutput: onNext).eraseToAnyPublisher()
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

// MARK: - startWith / prepend alias

public extension Publisher {
    func startWith(_ value: Output) -> AnyPublisher<Output, Failure> {
        prepend(value).eraseToAnyPublisher()
    }
}
