// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

public final class ActivityIndicator {
    private let lock = NSRecursiveLock()
    private let subject = CurrentValueSubject<Bool, Never>(false)

    public init() {}

    public func asDriver() -> AnyPublisher<Bool, Never> {
        subject.removeDuplicates().eraseToAnyPublisher()
    }
}

private extension ActivityIndicator {
    func start() {
        lock.lock(); subject.send(true); lock.unlock()
    }

    func stop() {
        lock.lock(); subject.send(false); lock.unlock()
    }

    func track<P: Publisher>(_ source: P) -> AnyPublisher<P.Output, P.Failure> {
        source
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.start() },
                receiveOutput: { [weak self] _ in self?.stop() },
                receiveCompletion: { [weak self] _ in self?.stop() },
                receiveCancel: { [weak self] in self?.stop() }
            )
            .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func trackActivity(_ indicator: ActivityIndicator) -> AnyPublisher<Output, Failure> {
        indicator.track(self)
    }
}
