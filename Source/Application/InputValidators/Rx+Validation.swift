//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
