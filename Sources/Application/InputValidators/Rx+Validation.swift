// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine

struct EditingValidation {
    let isEditing: Bool
    let validation: AnyValidation
}

extension AnyPublisher where Output == EditingValidation, Failure == Never {
    func eagerValidLazyErrorTurnedToEmptyOnEdit(
        directlyDisplayErrorMessages: AnyPublisher<String, Never> = Empty().eraseToAnyPublisher()
    ) -> AnyPublisher<AnyValidation, Never> {
        let editingValidation: AnyPublisher<AnyValidation, Never> = map {
            switch ($0.isEditing, $0.validation) {
            case (_, .valid): $0.validation
            case (false, _): $0.validation
            case (true, _): .empty
            }
        }.eraseToAnyPublisher()

        return AnyPublisher.merge(
            directlyDisplayErrorMessages.map { .errorMessage($0) },
            editingValidation
        )
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit(
        directlyDisplayTrackedErrors trackedErrors: AnyPublisher<some InputError, Never>
    ) -> AnyPublisher<AnyValidation, Never> {
        eagerValidLazyErrorTurnedToEmptyOnEdit(
            directlyDisplayErrorMessages: trackedErrors.map(\.errorMessage).eraseToAnyPublisher()
        )
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit(
        directlyDisplayErrorsTrackedBy errorTracker: ErrorTracker,
        mapError: @escaping (Swift.Error) -> (some InputError)?
    ) -> AnyPublisher<AnyValidation, Never> {
        eagerValidLazyErrorTurnedToEmptyOnEdit(
            directlyDisplayTrackedErrors: errorTracker.asInputErrors(mapError: mapError)
        )
    }
}

extension AnyPublisher where Failure == Never {
    func onlyErrors<V: ValidationConvertible>() -> AnyPublisher<AnyValidation, Never> where Output == V {
        map(\.validation)
            .compactMap { $0.isError ? $0 : nil }
            .eraseToAnyPublisher()
    }

    func nonErrors<V: ValidationConvertible>() -> AnyPublisher<AnyValidation, Never> where Output == V {
        map(\.validation)
            .compactMap { !$0.isError ? $0 : nil }
            .eraseToAnyPublisher()
    }
}
