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
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E == EditingValidation {
    func eagerValidLazyErrorTurnedToEmptyOnEdit() -> Driver<Validation> {
        return asDriver().map {
            switch ($0.isEditing, $0.validation.isValid) {
            // Always indicate valid
            case (_, true): return .valid
            // Always validate when stop editing
            case (false, _): return $0.validation
            // Convert (.error, .empty) -> empty when starting editing
            case (true, false): return .empty
            }
        }
    }
}
