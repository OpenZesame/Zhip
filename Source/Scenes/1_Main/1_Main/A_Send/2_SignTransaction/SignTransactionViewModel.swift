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
import RxSwift
import RxCocoa
import Zesame

enum SignTransactionUserAction: TrackableEvent {
    case sign(TransactionResponse)

    var eventName: String {
        switch self {
        case .sign: return "sign"
        }
    }
}

final class SignTransactionViewModel: BaseViewModel<
    SignTransactionUserAction,
    SignTransactionViewModel.InputFromView,
    SignTransactionViewModel.Output
> {

    private let transactionUseCase: TransactionsUseCase
    private let payment: Payment
    private let walletUseCase: WalletUseCase

    init(paymentToSign: Payment, walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase) {
        self.payment = paymentToSign
        self.walletUseCase = walletUseCase
        self.transactionUseCase = transactionUseCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        guard let _wallet = walletUseCase.loadWallet() else { incorrectImplementation("Should have wallet") }
        let _payment = payment

        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()

        // MARK: - Validate input
        let validator = InputValidator()

        let encryptionPasswordValidationValue = input.fromView.encryptionPassword
            .map { validator.validateEncryptionPassword($0, for: _wallet) }

        let encryptionPassword = encryptionPasswordValidationValue.map { $0.value?.validPassword }.filterNil()

        bag <~ [
            input.fromView.signAndSendTrigger
                .withLatestFrom(encryptionPassword)
                .flatMapLatest {
                    self.transactionUseCase.sendTransaction(for: _payment, wallet: _wallet, encryptionPassword: $0)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.sign($0)) })
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
                WalletEncryptionPassword.Error.incorrectPasswordErrorFrom(error: $0)
        }

        let isSignButtonEnabled = encryptionPasswordValidation.map { $0.isValid }

        return Output(
            isSignButtonEnabled: isSignButtonEnabled,
            isSignButtonLoading: activityIndicator.asDriver(),
            encryptionPasswordValidation: encryptionPasswordValidation,
            inputBecomeFirstResponder: input.fromController.viewDidAppear
        )
    }

}

extension SignTransactionViewModel {

    struct InputFromView {
        let encryptionPassword: Driver<String>
        let isEditingEncryptionPassword: Driver<Bool>
        let signAndSendTrigger: Driver<Void>
    }

    struct Output {
        let isSignButtonEnabled: Driver<Bool>
        let isSignButtonLoading: Driver<Bool>
        let encryptionPasswordValidation: Driver<AnyValidation>
        let inputBecomeFirstResponder: Driver<Void>
    }

    struct InputValidator {

        func validateEncryptionPassword(_ password: String, for wallet: Wallet) -> EncryptionPasswordValidator.Result {
            let validator = EncryptionPasswordValidator(mode: WalletEncryptionPassword.modeFrom(wallet: wallet))
            return validator.validate(input: (password: password, confirmingPassword: password))
        }
    }
}
