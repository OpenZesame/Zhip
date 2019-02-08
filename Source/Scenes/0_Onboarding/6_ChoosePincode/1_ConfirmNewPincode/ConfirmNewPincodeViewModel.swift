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
            .do(onNext: { [unowned self] in
                self.useCase.userChoose(pincode: $0)
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
