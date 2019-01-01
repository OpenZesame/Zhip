//
//  Rx+Validation.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

struct EditingValidation {
    let isEditing: Bool
    let validation: Validation

    init(isEditing: Bool, validation: Validation) {
        self.isEditing = isEditing
        self.validation = validation
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E == EditingValidation {

    func eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayErrorMessages: Driver<String> = .empty()) -> Driver<Validation> {
        let editingValidation: Driver<Validation> = asDriver().map {
            switch ($0.isEditing, $0.validation.isValid) {
            // Always indicate valid
            case (_, true): return .valid
            // Always validate when stop editing
            case (false, _): return $0.validation
            // Convert (.error, .empty) -> empty when starting editing
            case (true, false): return .empty
            }
        }

        return Driver.merge(
            directlyDisplayErrorMessages.map { .error(errorMessage: $0) },
            editingValidation
        )
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit<IE: InputError>(directlyDisplayTrackedErrors trackedErrors: Driver<IE>) -> Driver<Validation> {
        return eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayErrorMessages: trackedErrors.map { $0.errorMessage })
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit<IE: InputError>(directlyDisplayErrorsTrackedBy errorTracker: ErrorTracker, mapError: @escaping (Swift.Error) -> IE?) -> Driver<Validation> {
        return eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayTrackedErrors: errorTracker.asInputErrors(mapError: mapError))
    }
}
