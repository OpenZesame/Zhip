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

    private lazy var privateKeyField = UITextField.Style(€.Field.privateKey, isSecureTextEntry: true).make()
    private lazy var keystoreLabel = UILabel.Style(€.Label.orKeystore).make()
    private lazy var keystoreTextView = UITextView.Style("", height: 200).make()
    private lazy var encryptionPassphraseField = UITextField.Style(isSecureTextEntry: true).make()
    private lazy var confirmEncryptionPassphraseField = UITextField.Style(€.Field.confirmEncryptionPassphrase, isSecureTextEntry: true).make()
    private lazy var restoreWalletButton = UIButton.Style(€.Button.restoreWallet, isEnabled: false).make()

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
            viewModel.isRestoreButtonEnabled            --> restoreWalletButton.rx.isEnabled
        ]
    }
}
