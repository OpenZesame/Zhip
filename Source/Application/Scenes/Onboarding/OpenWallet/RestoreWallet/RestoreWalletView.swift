//
//  RestoreWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class RestoreWalletView: ScrollingStackView {

    private lazy var privateKeyField: UITextField = "Private Key"
    private lazy var keystoreLabel: UILabel = "Or paste keystore (JSON) below"
    private lazy var keystoreTextView: UITextView = ""
    private lazy var encryptionPassphraseField: UITextField = "Encryption passphrase"
    private lazy var confirmEncryptionPassphraseField: UITextField = "Confirm encryption passphrase"
    private lazy var restoreWalletButton = UIButton.Style("Restore Wallet", isEnabled: false).make()

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        keystoreLabel,
        keystoreTextView,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        restoreWalletButton,
        .spacer
    ]
}

extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var userInput: UserInput {
        return UserInput(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: RestoreWalletViewModel.Output) -> [Disposable] {
        return [
            viewModel.isRestoreButtonEnabled --> restoreWalletButton.rx.isEnabled
        ]
    }
}
