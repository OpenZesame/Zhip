// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

public final class ErrorTracker {
    private let subject = PassthroughSubject<Error, Never>()

    public init() {}

    public func asDriver() -> AnyPublisher<Error, Never> {
        subject.eraseToAnyPublisher()
    }

    public func track<P: Publisher>(from source: P) -> AnyPublisher<P.Output, Never>
        where P.Failure == Error {
        source
            .catch { [weak self] error -> Empty<P.Output, Never> in
                self?.subject.send(error)
                return Empty()
            }
            .eraseToAnyPublisher()
    }

    func asInputErrors<IE: InputError>(
        mapError: @escaping (Swift.Error) -> IE?
    ) -> AnyPublisher<IE, Never> {
        subject
            .compactMap { mapError($0) }
            .eraseToAnyPublisher()
    }

    func asInputValidationErrors(
        mapError: @escaping (Swift.Error) -> (some InputError)?
    ) -> AnyPublisher<AnyValidation, Never> {
        asInputErrors(mapError: mapError)
            .map { .errorMessage($0.errorMessage) }
            .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func trackError(_ tracker: ErrorTracker) -> AnyPublisher<Output, Never>
        where Failure == Error {
        tracker.track(from: self)
    }
}
