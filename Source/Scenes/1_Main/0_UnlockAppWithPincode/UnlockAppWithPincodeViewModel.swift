//
//  UnlockAppWithPincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - UnlockAppWithPincodeUserAction
enum UnlockAppWithPincodeUserAction: TrackedUserAction {
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

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let validator = InputValidator(existingPincode: pincode)

        let pincodeValidationValue = input.fromView.pincode.map {
            validator.validate(unconfirmedPincode: $0)
        }

        bag <~ [
             pincodeValidationValue.filter { $0.isValid }
                .mapToVoid()
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
        let pincodeValidation: Driver<Validation>
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
