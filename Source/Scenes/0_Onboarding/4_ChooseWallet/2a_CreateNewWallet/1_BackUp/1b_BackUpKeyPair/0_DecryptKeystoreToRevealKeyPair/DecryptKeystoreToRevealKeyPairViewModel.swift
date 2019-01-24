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

import Zesame

import RxSwift
import RxCocoa

enum DecryptKeystoreToRevealKeyPairUserAction: TrackableEvent {
    case dismiss
    case decryptKeystoreReavealing(keyPair: KeyPair)

    // Analytics
    var eventName: String {
        switch self {
        case .dismiss: return "dismiss"
        case .decryptKeystoreReavealing: return "decryptKeystoreReavealing"
        }
    }
}

private typealias € = L10n.Scene.DecryptKeystoreToRevealKeyPair

final class DecryptKeystoreToRevealKeyPairViewModel: BaseViewModel<
    DecryptKeystoreToRevealKeyPairUserAction,
    DecryptKeystoreToRevealKeyPairViewModel.InputFromView,
    DecryptKeystoreToRevealKeyPairViewModel.Output
> {

    private let useCase: WalletUseCase
    private let wallet: Driver<Wallet>

    init(useCase: WalletUseCase, wallet: Driver<Wallet>) {
        self.useCase = useCase
        self.wallet = wallet
    }

    // swiftlint:disable:next function_body_length
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

        let encryptionPassword = encryptionPasswordValidationValue.map { $0.value?.validPassword }.filterNil()

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.dismiss) })
                .drive(),

            input.fromView.revealTrigger
                .withLatestFrom(
                    Driver.combineLatest(
                        wallet,
                        encryptionPassword
                    )
                ) { (wallet: $1.0, password: $1.1) }
                .flatMapLatest { [unowned useCase] in
                    useCase.extractKeyPairFrom(wallet: $0.wallet, encryptedBy: $0.password)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.decryptKeystoreReavealing(keyPair: $0)) })
                .drive()
        ]

        let encryptionPasswordValidation = Driver.merge(
            // map `editingChanged` to `editingDidBegin`
            input.fromView.encryptionPassword.mapToVoid().map { true },
            input.fromView.isEditingEncryptionPassword
        ).withLatestFrom(encryptionPasswordValidationValue) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit(
            directlyDisplayErrorsTrackedBy: errorTracker
        ) {
            WalletEncryptionPassword.Error.incorrectPasswordErrorFrom(error: $0, backingUpWalletJustCreated: true)
        }

        return Output(
            encryptionPasswordValidation: encryptionPasswordValidation,
            isRevealButtonEnabled: encryptionPasswordValidationValue.map { $0.isValid },
            isRevealButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension DecryptKeystoreToRevealKeyPairViewModel {

    struct InputFromView {
        let encryptionPassword: Driver<String>
        let isEditingEncryptionPassword: Driver<Bool>
        let revealTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPasswordValidation: Driver<AnyValidation>
        let isRevealButtonEnabled: Driver<Bool>
        let isRevealButtonLoading: Driver<Bool>
    }

    struct InputValidator {

        func validateEncryptionPassword(_ password: String, for wallet: Wallet) -> EncryptionPasswordValidator.Result {
            let validator = EncryptionPasswordValidator(mode: WalletEncryptionPassword.modeFrom(wallet: wallet))
            return validator.validate(input: (password: password, confirmingPassword: password))
        }
    }
}

