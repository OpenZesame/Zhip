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

private typealias € = L10n.Scene.SignTransaction

final class SignTransactionView: ScrollingStackView {

    private lazy var confirmTransactionLabel = UILabel(text: €.Label.signTransactionWithEncryptionPassphrase).withStyle(.title)

    private lazy var encryptionPassphraseField = TextField(placeholder: €.Field.encryptionPassphrase, type: .text).withStyle(.password)

    private lazy var signButton: ButtonWithSpinner = ButtonWithSpinner(title: €.Button.confirm)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
        }
//        .disabled()

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
