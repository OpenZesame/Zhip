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
import LocalAuthentication
import RxCocoa
import RxSwift

// MARK: - UnlockAppWithPincodeUserAction
enum UnlockAppWithPincodeUserAction: String, TrackedUserAction {
    case unlockApp
}

// MARK: - UnlockAppWithPincodeViewModel
private typealias € = L10n.Scene.UnlockAppWithPincode
final class UnlockAppWithPincodeViewModel: BaseViewModel<
    UnlockAppWithPincodeUserAction,
    UnlockAppWithPincodeViewModel.InputFromView,
    UnlockAppWithPincodeViewModel.Output
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

        let pincodeValidationValue = input.fromView.pincode.map {
            validator.validate(unconfirmedPincode: $0)
        }

        func unlockUsingBiometrics() -> Driver<Void> {
            let context = LAContext()
            context.localizedFallbackTitle = €.Biometrics.fallBack
            var authError: NSError?

            // Is this ever used? I think that 'NSFaceIDUsageDescription' might override it?
            let reasonString = €.Biometrics.reason

            return Observable.create { observer in
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { didAuth, _ in
                        if didAuth {
                            observer.onNext(())
                        }
                    }
                }
                return Disposables.create {}
            }.asDriverOnErrorReturnEmpty()
        }

        let unlockUsingBiometricsTrigger = input.fromController.viewDidAppear

        bag <~ [
            Driver.merge(
                pincodeValidationValue.filter { $0.isValid }.mapToVoid(),
                unlockUsingBiometricsTrigger.flatMap { unlockUsingBiometrics() }
            )
                .do(onNext: { userDid(.unlockApp) })
                .drive()

        ]

        return Output(
            inputBecomeFirstResponder: input.fromController.viewWillAppear,
            pincodeValidation: pincodeValidationValue.map { $0.validation }
        )
    }
}

extension UnlockAppWithPincodeViewModel {
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
