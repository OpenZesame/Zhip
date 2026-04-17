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
import LocalAuthentication

// MARK: - UnlockAppWithPincodeUserAction

enum UnlockAppWithPincodeUserAction {
    case unlockApp
}

// MARK: - UnlockAppWithPincodeViewModel

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

        // Always resolves the promise (even on unavailable / cancel / failure) so the publisher
        // completes and doesn't leave dangling inner subscriptions when used under flatMap.
        func unlockUsingBiometrics() -> AnyPublisher<Void, Never> {
            Deferred {
                Future<Bool, Never> { promise in
                    let context = LAContext()
                    context.localizedFallbackTitle = String(localized: .UnlockApp.biometricsFallback)
                    // Is this ever used? I think that 'NSFaceIDUsageDescription' might override it?
                    let reasonString = String(localized: .UnlockApp.biometricsReason)
                    var authError: NSError?
                    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
                        promise(.success(false))
                        return
                    }
                    context.evaluatePolicy(
                        .deviceOwnerAuthenticationWithBiometrics,
                        localizedReason: reasonString
                    ) { didAuth, _ in
                        promise(.success(didAuth))
                    }
                }
            }
            .filter { $0 }
            .mapToVoid()
            .eraseToAnyPublisher()
        }

        let unlockUsingBiometricsTrigger = input.fromController.viewDidAppear

        [
            pincodeValidationValue.filter(\.isValid).mapToVoid()
                .merge(with: unlockUsingBiometricsTrigger.flatMapLatest { unlockUsingBiometrics() })
                .receive(on: DispatchQueue.main)
                .sink { userDid(.unlockApp) },
        ].forEach { $0.store(in: &cancellables) }

        return Output(
            inputBecomeFirstResponder: input.fromController.viewWillAppear,
            pincodeValidation: pincodeValidationValue.map(\.validation).eraseToAnyPublisher()
        )
    }
}

extension UnlockAppWithPincodeViewModel {
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
