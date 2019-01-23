//
//  UnlockAppWithPincodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
