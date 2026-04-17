//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Foundation

// MARK: - RemovePincodeUserAction

enum RemovePincodeUserAction {
    case cancelPincodeRemoval
    case removePincode
}

// MARK: - RemovePincodeViewModel

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

    override func transform(input: Input) -> RemovePincodeViewModel.Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let validator = InputValidator(existingPincode: pincode)

        let pincodeValidationValue: AnyPublisher<PincodeValidator.ValidationResult, Never> = input.fromView.pincode.map {
            validator.validate(unconfirmedPincode: $0)
        }.eraseToAnyPublisher()

        [
            input.fromController.leftBarButtonTrigger
                .handleEvents(receiveOutput: { userDid(.cancelPincodeRemoval) })
                .sink { _ in },

            pincodeValidationValue.filter(\.isValid)
                .mapToVoid()
                .handleEvents(receiveOutput: { [unowned useCase] in
                    useCase.deletePincode()
                    userDid(.removePincode)
                })
                .sink { _ in },
        ].forEach { $0.store(in: &cancellables) }

        return Output(
            inputBecomeFirstResponder: input.fromController.viewDidAppear,
            pincodeValidation: pincodeValidationValue.map(\.validation).eraseToAnyPublisher()
        )
    }
}

extension RemovePincodeViewModel {
    struct InputFromView {
        let pincode: AnyPublisher<Pincode?, Never>
    }

    struct Output {
        let inputBecomeFirstResponder: AnyPublisher<Void, Never>
        let pincodeValidation: AnyPublisher<AnyValidation, Never>
    }

    struct InputValidator {
        private let existingPincode: Pincode
        private let pincodeValidator = PincodeValidator(settingNew: false)

        init(existingPincode: Pincode) {
            self.existingPincode = existingPincode
        }

        func validate(unconfirmedPincode: Pincode?) -> PincodeValidator.ValidationResult {
            pincodeValidator.validate(input: (unconfirmedPincode, existingPincode))
        }
    }
}
