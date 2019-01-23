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

// MARK: - RemovePincodeUserAction
enum RemovePincodeUserAction: String, TrackedUserAction {
    case cancelPincodeRemoval
    case removePincode
}

// MARK: - RemovePincodeViewModel
private typealias € = L10n.Scene.RemovePincode
final class RemovePincodeViewModel: BaseViewModel<
    RemovePincodeUserAction,
    RemovePincodeViewModel.InputFromView,
    RemovePincodeViewModel.Output
> {

    private let useCase: PincodeUseCase
    private let pincode: Pincode

    init(useCase: PincodeUseCase) {
        self.useCase = useCase
        guard let pincode = useCase.pincode else {
            incorrectImplementation("Should have pincode set")
        }
        self.pincode = pincode
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let validator = InputValidator(existingPincode: pincode)

        let pincodeValidationValue: Driver<PincodeValidator.Result> = input.fromView.pincode.map {
            return validator.validate(unconfirmedPincode: $0)
        }

        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancelPincodeRemoval) })
                .drive(),

            pincodeValidationValue.filter { $0.isValid }
                .mapToVoid()
                .do(onNext: { [unowned useCase] in
                    useCase.deletePincode()
                    userDid(.removePincode)
                })
                .drive()
        ]

        return Output(
            inputBecomeFirstResponder: input.fromController.viewDidAppear,
            pincodeValidation: pincodeValidationValue.map { $0.validation }
        )
    }
}

extension RemovePincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
    }

    struct Output {
        let inputBecomeFirstResponder: Driver<Void>
        let pincodeValidation: Driver<AnyValidation>
    }

    struct InputValidator {

        private let existingPincode: Pincode
        private let pincodeValidator = PincodeValidator(settingNew: false)

        init(existingPincode: Pincode) {
            self.existingPincode = existingPincode
        }

        func validate(unconfirmedPincode: Pincode?) -> PincodeValidator.Result {
            return pincodeValidator.validate(input: (unconfirmedPincode, existingPincode))
        }
    }
}
