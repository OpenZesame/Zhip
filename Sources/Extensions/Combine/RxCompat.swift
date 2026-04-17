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

    // Variadic overload for pre-erased publishers
    static func merge(_ publishers: AnyPublisher<Output, Never>...) -> AnyPublisher<Output, Never> {
        Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }

    static func merge(_ publishers: [AnyPublisher<Output, Never>]) -> AnyPublisher<Output, Never> {
        Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }

    // Overloads that accept any Publisher (auto-erases, avoids call-site .eraseToAnyPublisher())
    static func merge(
        _ p1: some Publisher<Output, Never>,
        _ p2: some Publisher<Output, Never>
    ) -> AnyPublisher<Output, Never> {
        p1.eraseToAnyPublisher()
            .merge(with: p2.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }

    static func merge(
        _ p1: some Publisher<Output, Never>,
        _ p2: some Publisher<Output, Never>,
        _ p3: some Publisher<Output, Never>
    ) -> AnyPublisher<Output, Never> {
        Publishers.Merge3(
            p1.eraseToAnyPublisher(),
            p2.eraseToAnyPublisher(),
            p3.eraseToAnyPublisher()
        ).eraseToAnyPublisher()
    }

    static func merge(
        _ p1: some Publisher<Output, Never>,
        _ p2: some Publisher<Output, Never>,
        _ p3: some Publisher<Output, Never>,
        _ p4: some Publisher<Output, Never>
    ) -> AnyPublisher<Output, Never> {
        Publishers.Merge4(
            p1.eraseToAnyPublisher(),
            p2.eraseToAnyPublisher(),
            p3.eraseToAnyPublisher(),
            p4.eraseToAnyPublisher()
        ).eraseToAnyPublisher()
    }
}

// MARK: - combineLatest free functions

public func combineLatest<A, B>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>
) -> AnyPublisher<(A, B), Never> {
    a.eraseToAnyPublisher().combineLatest(b).eraseToAnyPublisher()
}

// swiftlint:disable large_tuple
public func combineLatest<A, B, C>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    _ c: some Publisher<C, Never>
) -> AnyPublisher<(A, B, C), Never> {
    a.eraseToAnyPublisher().combineLatest(b, c).eraseToAnyPublisher()
}

public func combineLatest<A, B, C, D>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    _ c: some Publisher<C, Never>,
    _ d: some Publisher<D, Never>
) -> AnyPublisher<(A, B, C, D), Never> {
    a.eraseToAnyPublisher().combineLatest(b, c, d).eraseToAnyPublisher()
}
// swiftlint:enable large_tuple

public func combineLatest<A, B, R>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    resultSelector: @escaping (A, B) -> R
) -> AnyPublisher<R, Never> {
    a.eraseToAnyPublisher().combineLatest(b, resultSelector).eraseToAnyPublisher()
}

public func combineLatest<A, B, C, R>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    _ c: some Publisher<C, Never>,
    resultSelector: @escaping (A, B, C) -> R
) -> AnyPublisher<R, Never> {
    a.eraseToAnyPublisher()
        .combineLatest(b.eraseToAnyPublisher(), c.eraseToAnyPublisher(), resultSelector)
        .eraseToAnyPublisher()
}

// swiftlint:disable function_parameter_count
public func combineLatest<A, B, C, D, R>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    _ c: some Publisher<C, Never>,
    _ d: some Publisher<D, Never>,
    resultSelector: @escaping (A, B, C, D) -> R
) -> AnyPublisher<R, Never> {
    Publishers.CombineLatest4(
        a.eraseToAnyPublisher(),
        b.eraseToAnyPublisher(),
        c.eraseToAnyPublisher(),
        d.eraseToAnyPublisher()
    )
    .map { resultSelector($0.0, $0.1, $0.2, $0.3) }
    .eraseToAnyPublisher()
}

public func combineLatest<A, B, C, D, E, R>(
    _ a: some Publisher<A, Never>,
    _ b: some Publisher<B, Never>,
    _ c: some Publisher<C, Never>,
    _ d: some Publisher<D, Never>,
    _ e: some Publisher<E, Never>,
    resultSelector: @escaping (A, B, C, D, E) -> R
) -> AnyPublisher<R, Never> {
    Publishers.CombineLatest4(
        a.eraseToAnyPublisher(),
        b.eraseToAnyPublisher(),
        c.eraseToAnyPublisher(),
        d.eraseToAnyPublisher()
    )
    .combineLatest(e.eraseToAnyPublisher())
    .map { tuple4, eVal in resultSelector(tuple4.0, tuple4.1, tuple4.2, tuple4.3, eVal) }
    .eraseToAnyPublisher()
}
// swiftlint:enable function_parameter_count

// MARK: - Driver.combineLatest(...) call syntax

public extension AnyPublisher where Failure == Never {
    static func combineLatest<A, B>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>
    ) -> AnyPublisher<(A, B), Never> {
        a.eraseToAnyPublisher().combineLatest(b).eraseToAnyPublisher()
    }

    // swiftlint:disable large_tuple
    static func combineLatest<A, B, C>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        _ c: some Publisher<C, Never>
    ) -> AnyPublisher<(A, B, C), Never> {
        a.eraseToAnyPublisher().combineLatest(b, c).eraseToAnyPublisher()
    }

    static func combineLatest<A, B, C, D>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        _ c: some Publisher<C, Never>,
        _ d: some Publisher<D, Never>
    ) -> AnyPublisher<(A, B, C, D), Never> {
        a.eraseToAnyPublisher().combineLatest(b, c, d).eraseToAnyPublisher()
    }
    // swiftlint:enable large_tuple

    static func combineLatest<A, B, R>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        resultSelector: @escaping (A, B) -> R
    ) -> AnyPublisher<R, Never> {
        a.eraseToAnyPublisher().combineLatest(b, resultSelector).eraseToAnyPublisher()
    }

    static func combineLatest<A, B, C, R>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        _ c: some Publisher<C, Never>,
        resultSelector: @escaping (A, B, C) -> R
    ) -> AnyPublisher<R, Never> {
        a.eraseToAnyPublisher()
            .combineLatest(b.eraseToAnyPublisher(), c.eraseToAnyPublisher(), resultSelector)
            .eraseToAnyPublisher()
    }

    // swiftlint:disable function_parameter_count
    static func combineLatest<A, B, C, D, R>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        _ c: some Publisher<C, Never>,
        _ d: some Publisher<D, Never>,
        resultSelector: @escaping (A, B, C, D) -> R
    ) -> AnyPublisher<R, Never> {
        Publishers.CombineLatest4(
            a.eraseToAnyPublisher(),
            b.eraseToAnyPublisher(),
            c.eraseToAnyPublisher(),
            d.eraseToAnyPublisher()
        )
        .map { resultSelector($0.0, $0.1, $0.2, $0.3) }
        .eraseToAnyPublisher()
    }

    static func combineLatest<A, B, C, D, E, R>(
        _ a: some Publisher<A, Never>,
        _ b: some Publisher<B, Never>,
        _ c: some Publisher<C, Never>,
        _ d: some Publisher<D, Never>,
        _ e: some Publisher<E, Never>,
        resultSelector: @escaping (A, B, C, D, E) -> R
    ) -> AnyPublisher<R, Never> {
        Publishers.CombineLatest4(
            a.eraseToAnyPublisher(),
            b.eraseToAnyPublisher(),
            c.eraseToAnyPublisher(),
            d.eraseToAnyPublisher()
        )
        .combineLatest(e.eraseToAnyPublisher())
        .map { tuple4, eVal in resultSelector(tuple4.0, tuple4.1, tuple4.2, tuple4.3, eVal) }
        .eraseToAnyPublisher()
    }
    // swiftlint:enable function_parameter_count
}
