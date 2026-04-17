// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine

struct EditingValidation {
    let isEditing: Bool
    let validation: AnyValidation
}

extension Publisher where Output == EditingValidation, Failure == Never {
    func eagerValidLazyErrorTurnedToEmptyOnEdit(
        directlyDisplayErrorMessages: AnyPublisher<String, Never> = Empty().eraseToAnyPublisher()
    ) -> AnyPublisher<AnyValidation, Never> {
        let editingValidation = map { (input: EditingValidation) -> AnyValidation in
            switch (input.isEditing, input.validation) {
            case (_, .valid): input.validation
            case (false, _): input.validation
            case (true, _): .empty
            }
        }

        return directlyDisplayErrorMessages
            .map { AnyValidation.errorMessage($0) }
            .merge(with: editingValidation)
            .eraseToAnyPublisher()
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

extension Publisher where Failure == Never, Output: ValidationConvertible {
    func onlyErrors() -> AnyPublisher<AnyValidation, Never> {
        map(\.validation)
            .compactMap { $0.isError ? $0 : nil }
            .eraseToAnyPublisher()
    }

    func nonErrors() -> AnyPublisher<AnyValidation, Never> {
        map(\.validation)
            .compactMap { !$0.isError ? $0 : nil }
            .eraseToAnyPublisher()
    }
}
