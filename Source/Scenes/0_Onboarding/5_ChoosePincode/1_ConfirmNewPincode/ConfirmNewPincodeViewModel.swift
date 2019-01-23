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

import Foundation
import RxCocoa
import RxSwift

// MARK: - ConfirmNewPincodeUserAction
enum ConfirmNewPincodeUserAction: String, TrackedUserAction {
    case confirmPincode
    case skip
}

// MARK: - ConfirmNewPincodeViewModel
final class ConfirmNewPincodeViewModel: BaseViewModel<
    ConfirmNewPincodeUserAction,
    ConfirmNewPincodeViewModel.InputFromView,
    ConfirmNewPincodeViewModel.Output
> {
    private let useCase: PincodeUseCase
    private let unconfirmedPincode: Pincode

    init(useCase: PincodeUseCase, confirm unconfirmedPincode: Pincode) {
        self.useCase = useCase
        self.unconfirmedPincode = unconfirmedPincode
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let validator = InputValidator(existingPincode: unconfirmedPincode)

        let pincodeValidationValue = input.fromView.pincode.map {
            validator.validate(unconfirmedPincode: $0)
        }
        let isConfirmPincodeEnabled = Driver.combineLatest(
            pincodeValidationValue.map { $0.isValid },
            input.fromView.isHaveBackedUpPincodeCheckboxChecked
        ) { isPincodeValid, isBackedUpChecked in
            isPincodeValid && isBackedUpChecked
        }

        bag <~ [
            input.fromView.confirmedTrigger.withLatestFrom(pincodeValidationValue.map { $0.value }.filterNil())
            .do(onNext: { [unowned useCase] in
                useCase.userChoose(pincode: $0)
                userDid(.confirmPincode)
            }).drive(),

            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.skip) })
                .drive()
        ]

        return Output(
            pincodeValidation: pincodeValidationValue.map { $0.validation },
            isConfirmPincodeEnabled: isConfirmPincodeEnabled,
            inputBecomeFirstResponder: input.fromController.viewDidAppear
        )
    }
}

extension ConfirmNewPincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
        let isHaveBackedUpPincodeCheckboxChecked: Driver<Bool>
        let confirmedTrigger: Driver<Void>
    }

    struct Output {
        let pincodeValidation: Driver<AnyValidation>
        let isConfirmPincodeEnabled: Driver<Bool>
        let inputBecomeFirstResponder: Driver<Void>
    }

    struct InputValidator {

        private let existingPincode: Pincode
        private let pincodeValidator = PincodeValidator(settingNew: true)

        init(existingPincode: Pincode) {
            self.existingPincode = existingPincode
        }

        func validate(unconfirmedPincode: Pincode?) -> PincodeValidator.Result {
            return pincodeValidator.validate(input: (unconfirmedPincode, existingPincode))
        }
    }
}

struct PincodeValidator: InputValidator {
    typealias Output = Pincode
    enum Error: InputError {
        case incorrectPincode(settingNew: Bool)
    }

    private let settingNew: Bool
    init(settingNew: Bool = false) {
        self.settingNew = settingNew
    }

    func validate(input: (unconfirmed: Pincode?, existing: Pincode)) -> Result {

        let pincode = input.existing

        guard let unconfirmed = input.unconfirmed else {
            return .invalid(.empty)
        }

        guard unconfirmed == pincode else {
            return .invalid(.error(Error.incorrectPincode(settingNew: settingNew)))
        }
        return .valid(pincode)
    }
}

extension PincodeValidator.Error {
    var errorMessage: String {
        let Message = L10n.Error.Input.Pincode.self

        switch self {
        case .incorrectPincode(let settingNew):
            if settingNew {
                return Message.pincodesDoesNotMatch
            } else {
                return Message.pincodesDoesNotMatch
            }
        }
    }
}
