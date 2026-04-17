// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

// MARK: - --> binding operator

infix operator -->

/// Binds a `Never`-failing publisher to a `Binder` — the write-only, main-thread
/// sink primitive used throughout `populate(with:)` implementations.
///
/// The result `AnyCancellable` is `@discardableResult` because `populate(with:)`
/// conventionally returns a `[AnyCancellable]` that the `SceneController` retains.
@discardableResult
public func --> <T>(publisher: AnyPublisher<T, Never>, binder: Binder<T>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

/// `-->` overload: binds a non-optional publisher into a `Binder` that accepts an
/// optional. Implicitly lifts the value to `.some(...)`.
@discardableResult
public func --> <T>(publisher: AnyPublisher<T, Never>, binder: Binder<T?>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

/// `-->` overload: binds an optional publisher into a `Binder` of the same optional
/// type.
@discardableResult
public func --> <T>(publisher: AnyPublisher<T?, Never>, binder: Binder<T?>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

/// `-->` overload: binds a string publisher directly into a `UILabel`'s `text`.
/// `[weak label]` prevents a retain cycle if the label outlives the controller.
@discardableResult
public func --> (publisher: AnyPublisher<String, Never>, label: UILabel) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak label] in label?.text = $0 }
}

/// `-->` overload: same as the `String` variant but for optional strings.
@discardableResult
public func --> (publisher: AnyPublisher<String?, Never>, label: UILabel) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak label] in label?.text = $0 }
}

/// `-->` overload: binds a string publisher directly into a `UITextView`'s `text`.
@discardableResult
public func --> (publisher: AnyPublisher<String, Never>, textView: UITextView) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak textView] in textView?.text = $0 }
}

/// `-->` overload: same as the `String` variant but for optional strings.
@discardableResult
public func --> (publisher: AnyPublisher<String?, Never>, textView: UITextView) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak textView] in textView?.text = $0 }
}
