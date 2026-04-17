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
import Zesame

enum DecryptKeystoreToRevealKeyPairUserAction {
    case dismiss
    case decryptKeystoreReavealing(keyPair: KeyPair)
}

final class DecryptKeystoreToRevealKeyPairViewModel: BaseViewModel<
    DecryptKeystoreToRevealKeyPairUserAction,
    DecryptKeystoreToRevealKeyPairViewModel.InputFromView,
    DecryptKeystoreToRevealKeyPairViewModel.Output
> {
    private let useCase: WalletUseCase
    private let wallet: AnyPublisher<Wallet, Never>

    init(useCase: WalletUseCase, wallet: AnyPublisher<Wallet, Never>) {
        self.useCase = useCase
        self.wallet = wallet
    }

    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        // MARK: - Validate input

        let validator = InputValidator()

        let encryptionPasswordValidationValue = input.fromView.encryptionPassword
            .withLatestFrom(wallet) { (password: $0, wallet: $1) }
            .map { validator.validateEncryptionPassword($0.password, for: $0.wallet) }
            .eraseToAnyPublisher()

        let encryptionPassword = encryptionPasswordValidationValue.map { $0.value?.validPassword }.filterNil()

        [
            input.fromController.rightBarButtonTrigger
                .handleEvents(receiveOutput: { userDid(.dismiss) })
                .sink { _ in },

            input.fromView.revealTrigger
                .withLatestFrom(
                    wallet.combineLatest(encryptionPassword).eraseToAnyPublisher()
                ) { (_: Void, pair: (Wallet, String)) -> (wallet: Wallet, password: String) in
                    (wallet: pair.0, password: pair.1)
                }
                .flatMapLatest { [unowned useCase] in
                    useCase.extractKeyPairFrom(wallet: $0.wallet, encryptedBy: $0.password)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .replaceErrorWithEmpty()
                }
                .handleEvents(receiveOutput: { userDid(.decryptKeystoreReavealing(keyPair: $0)) })
                .sink { _ in },
        ].forEach { $0.store(in: &cancellables) }

        // map `editingChanged` to `editingDidBegin`
        let encryptionPasswordEditingTrigger = input.fromView.encryptionPassword.mapToVoid().map { true }
            .merge(with: input.fromView.isEditingEncryptionPassword)
            .eraseToAnyPublisher()

        let encryptionPasswordValidation = encryptionPasswordEditingTrigger
            .withLatestFrom(encryptionPasswordValidationValue) {
                EditingValidation(isEditing: $0, validation: $1.validation)
            }
            .eagerValidLazyErrorTurnedToEmptyOnEdit(
                directlyDisplayErrorsTrackedBy: errorTracker
            ) {
                WalletEncryptionPassword.Error.incorrectPasswordErrorFrom(error: $0, backingUpWalletJustCreated: true)
            }

        return Output(
            encryptionPasswordValidation: encryptionPasswordValidation,
            isRevealButtonEnabled: encryptionPasswordValidationValue.map(\.isValid).eraseToAnyPublisher(),
            isRevealButtonLoading: activityIndicator.asPublisher()
        )
    }
}

extension DecryptKeystoreToRevealKeyPairViewModel {
    struct InputFromView {
        let encryptionPassword: AnyPublisher<String, Never>
        let isEditingEncryptionPassword: AnyPublisher<Bool, Never>
        let revealTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let encryptionPasswordValidation: AnyPublisher<AnyValidation, Never>
        let isRevealButtonEnabled: AnyPublisher<Bool, Never>
        let isRevealButtonLoading: AnyPublisher<Bool, Never>
    }

    struct InputValidator {
        func validateEncryptionPassword(_ password: String, for wallet: Wallet) -> EncryptionPasswordValidator
            .ValidationResult
        {
            let validator = EncryptionPasswordValidator(mode: WalletEncryptionPassword.modeFrom(wallet: wallet))
            return validator.validate(input: (password: password, confirmingPassword: password))
        }
    }
}
