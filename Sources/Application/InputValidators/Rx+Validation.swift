// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
