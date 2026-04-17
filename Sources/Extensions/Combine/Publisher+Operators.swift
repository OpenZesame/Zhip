// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

// MARK: - --> binding operator

infix operator -->

/// Bind a Driver to a Binder (write-only, main-thread sink).
@discardableResult
public func --> <T>(publisher: AnyPublisher<T, Never>, binder: Binder<T>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

@discardableResult
public func --> <T>(publisher: AnyPublisher<T, Never>, binder: Binder<T?>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

@discardableResult
public func --> <T>(publisher: AnyPublisher<T?, Never>, binder: Binder<T?>) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { binder.on($0) }
}

@discardableResult
public func --> (publisher: AnyPublisher<String, Never>, label: UILabel) -> AnyCancellable {
    publisher --> label.rx.text
}

@discardableResult
public func --> (publisher: AnyPublisher<String, Never>, textView: UITextView) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak textView] in textView?.text = $0 }
}

@discardableResult
public func --> (publisher: AnyPublisher<String?, Never>, textView: UITextView) -> AnyCancellable {
    publisher.receive(on: RunLoop.main).sink { [weak textView] in textView?.text = $0 }
}

// MARK: - <~ store-in-bag operators

infix operator <~

public func <~ (bag: CancellableBag, cancellable: AnyCancellable) {
    cancellable.store(in: &bag.cancellables)
}

public func <~ (bag: CancellableBag, cancellables: [AnyCancellable?]) {
    cancellables.compactMap { $0 }.forEach { $0.store(in: &bag.cancellables) }
}
