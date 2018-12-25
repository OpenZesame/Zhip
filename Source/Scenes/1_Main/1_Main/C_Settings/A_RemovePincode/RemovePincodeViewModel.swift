//
//  RemovePincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - RemovePincodeUserAction
enum RemovePincodeUserAction: TrackedUserAction {
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
