//
//  SignTransactionView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-17.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignTransactionView: ScrollingStackView {

    private lazy var confirmTransactionLabel        = UILabel()
    private lazy var encryptionPassphraseField      = FloatingLabelTextField()
    private lazy var signButton                     = ButtonWithSpinner()

    lazy var stackViewStyle: UIStackView.Style = [
        confirmTransactionLabel,
        encryptionPassphraseField,
        signButton,
        .spacer
    ]
}

extension SignTransactionView: ViewModelled {
    typealias ViewModel = SignTransactionViewModel

    func populate(with viewModel: SignTransactionViewModel.Output) -> [Disposable] {
        return [
            viewModel.isSignButtonEnabled --> signButton.rx.isEnabled,
            viewModel.isSignButtonLoading --> signButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriverOnErrorReturnEmpty(),
            signAndSendTrigger: signButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.SignTransaction
private extension SignTransactionView {
    func setupSubviews() {
        confirmTransactionLabel.withStyle(.header) {
            $0.text(€.Label.signTransactionWithEncryptionPassphrase)
        }

        encryptionPassphraseField.withStyle(.passphrase) {
            $0.placeholder(€.Field.encryptionPassphrase)
        }

        signButton.withStyle(.primary) {
            $0.title(€.Button.confirm)
                .disabled()
        }
    }
}
