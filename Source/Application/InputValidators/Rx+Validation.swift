//
//  Rx+Validation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

struct EditingValidation {
    let isEditing: Bool
    let validation: AnyValidation

    init(isEditing: Bool, validation: AnyValidation) {
        self.isEditing = isEditing
        self.validation = validation
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E == EditingValidation {

    func eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayErrorMessages: Driver<String> = .empty()) -> Driver<AnyValidation> {
        let editingValidation: Driver<AnyValidation> = asDriver().map {
            switch ($0.isEditing, $0.validation) {
            // Always indicate valid
            case (_, .valid): return $0.validation
            // Always validate when stop editing
            case (false, _): return $0.validation
            // Convert (.error, .empty) -> empty when starting editing
            case (true, _): return .empty
            }
        }

        return Driver.merge(
            directlyDisplayErrorMessages.map { .errorMessage($0) },
            editingValidation
        )
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit<IE: InputError>(directlyDisplayTrackedErrors trackedErrors: Driver<IE>) -> Driver<AnyValidation> {
        return eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayErrorMessages: trackedErrors.map { $0.errorMessage })
    }

    func eagerValidLazyErrorTurnedToEmptyOnEdit<IE: InputError>(directlyDisplayErrorsTrackedBy errorTracker: ErrorTracker, mapError: @escaping (Swift.Error) -> IE?) -> Driver<AnyValidation> {
        return eagerValidLazyErrorTurnedToEmptyOnEdit(directlyDisplayTrackedErrors: errorTracker.asInputErrors(mapError: mapError))
    }
}
