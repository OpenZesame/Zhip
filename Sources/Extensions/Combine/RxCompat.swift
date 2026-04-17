// MIT License — Copyright (c) 2018-2026 Open Zesame
//
// Type-level compatibility shims so that existing type annotations
// (Driver<T>, PublishSubject<T>, BehaviorSubject<T>) compile without changes.

import Combine
import Foundation

// MARK: - Driver

public typealias Driver<T> = AnyPublisher<T, Never>

// MARK: - Subject shims

public typealias PublishSubject<T> = PassthroughSubject<T, Never>
public typealias BehaviorSubject<T> = CurrentValueSubject<T, Never>

// onNext / onCompleted bridge so existing call sites compile.
public extension PassthroughSubject where Failure == Never {
    func onNext(_ value: Output) { send(value) }
    func onCompleted() { send(completion: .finished) }
}

public extension CurrentValueSubject where Failure == Never {
    func onNext(_ value: Output) { send(value) }
    func onCompleted() { send(completion: .finished) }
}

// MARK: - AnyPublisher static constructors (match Driver.just / Driver.merge / etc.)

public extension AnyPublisher where Failure == Never {
    static func just(_ value: Output) -> AnyPublisher<Output, Never> {
        Just(value).eraseToAnyPublisher()
    }

    static func empty() -> AnyPublisher<Output, Never> {
        Empty<Output, Never>().eraseToAnyPublisher()
    }

    static func never() -> AnyPublisher<Output, Never> {
        Empty<Output, Never>(completeImmediately: false).eraseToAnyPublisher()
    }

    static func merge(_ publishers: AnyPublisher<Output, Never>...) -> AnyPublisher<Output, Never> {
        Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }

    static func merge(_ publishers: [AnyPublisher<Output, Never>]) -> AnyPublisher<Output, Never> {
        Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }
}

// combineLatest with 2 publishers of possibly different types
public func combineLatest<A, B>(
    _ a: AnyPublisher<A, Never>,
    _ b: AnyPublisher<B, Never>
) -> AnyPublisher<(A, B), Never> {
    a.combineLatest(b).eraseToAnyPublisher()
}

// swiftlint:disable large_tuple
public func combineLatest<A, B, C>(
    _ a: AnyPublisher<A, Never>,
    _ b: AnyPublisher<B, Never>,
    _ c: AnyPublisher<C, Never>
) -> AnyPublisher<(A, B, C), Never> {
    a.combineLatest(b, c).eraseToAnyPublisher()
}
// swiftlint:enable large_tuple

public func combineLatest<A, B, R>(
    _ a: AnyPublisher<A, Never>,
    _ b: AnyPublisher<B, Never>,
    resultSelector: @escaping (A, B) -> R
) -> AnyPublisher<R, Never> {
    a.combineLatest(b, resultSelector).eraseToAnyPublisher()
}

// Allow Driver.combineLatest(...) call syntax via AnyPublisher extension.
// Swift resolves Driver<T>.combineLatest → AnyPublisher<T,Never>.combineLatest.
public extension AnyPublisher where Failure == Never {
    static func combineLatest<A, B>(
        _ a: AnyPublisher<A, Never>,
        _ b: AnyPublisher<B, Never>
    ) -> AnyPublisher<(A, B), Never> {
        Zhip.combineLatest(a, b)
    }

    // swiftlint:disable large_tuple
    static func combineLatest<A, B, C>(
        _ a: AnyPublisher<A, Never>,
        _ b: AnyPublisher<B, Never>,
        _ c: AnyPublisher<C, Never>
    ) -> AnyPublisher<(A, B, C), Never> {
        Zhip.combineLatest(a, b, c)
    }
    // swiftlint:enable large_tuple

    static func combineLatest<A, B, R>(
        _ a: AnyPublisher<A, Never>,
        _ b: AnyPublisher<B, Never>,
        resultSelector: @escaping (A, B) -> R
    ) -> AnyPublisher<R, Never> {
        Zhip.combineLatest(a, b, resultSelector: resultSelector)
    }
}
