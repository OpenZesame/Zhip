// MIT License — Copyright (c) 2018-2026 Open Zesame
//
// Bridges RxSwift `Observable` (from Zesame) to Combine `AnyPublisher`.
// Once Zesame migrates to Combine/async-await, this file can be deleted.

import Combine
import Foundation
import RxSwift

extension ObservableConvertibleType {
    /// Cold, error-propagating bridge: each Combine subscriber starts its own Rx
    /// subscription, Rx errors become `.failure(error)`, and Combine cancellation
    /// disposes the Rx subscription.
    func asAnyPublisher() -> AnyPublisher<Element, Error> {
        let source = self.asObservable()
        return Deferred { () -> AnyPublisher<Element, Error> in
            let subject = PassthroughSubject<Element, Error>()
            let disposable = Atomic<RxSwift.Disposable?>(nil)
            return subject
                .handleEvents(
                    receiveSubscription: { _ in
                        disposable.value = source.subscribe(
                            onNext: { subject.send($0) },
                            onError: { subject.send(completion: .failure($0)) },
                            onCompleted: { subject.send(completion: .finished) }
                        )
                    },
                    receiveCancel: { disposable.value?.dispose() }
                )
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

private final class Atomic<Value> {
    private let lock = NSLock()
    private var _value: Value
    init(_ value: Value) { _value = value }
    var value: Value {
        get { lock.lock(); defer { lock.unlock() }; return _value }
        set { lock.lock(); _value = newValue; lock.unlock() }
    }
}
