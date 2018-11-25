//
//  RestoreWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

final class RestoreWalletView: ScrollingStackView {

    private lazy var privateKeyField = TextField(placeholder: €.Field.privateKey, type: .hexadecimal)
        .withStyle(.password)

    private lazy var keystoreLabel = UILabel(text: €.Label.orKeystore).withStyle(.title)

    private lazy var keystoreTextView = UITextView(frame: .zero).withStyle(.editable)

    private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

    private lazy var confirmEncryptionPassphraseField = TextField(placeholder: €.Field.confirmEncryptionPassphrase, type: .text).withStyle(.password)

    private lazy var restoreWalletButton: ButtonWithSpinner = ButtonWithSpinner(title: €.Button.restoreWallet)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
    }
    //        .disabled()

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        keystoreLabel,
        keystoreTextView,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        restoreWalletButton,
        .spacer
    ]

    override func setup() {
        keystoreTextView.addBorder()
        keystoreTextView.height(200)
    }
}

import RxCocoa
extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var inputFromView: InputFromView {

        return InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: RestoreWalletViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPassphrasePlaceholder   --> encryptionPassphraseField.rx.placeholder,
            viewModel.isRestoreButtonEnabled            --> restoreWalletButton.rx.isEnabled,
            viewModel.isRestoreButtonLoading            --> restoreWalletButton.rx.isLoading
        ]
    }
}
