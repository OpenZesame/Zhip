//
//  CreateNewWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class CreateNewWalletView: ScrollingStackView {

    private lazy var encryptionPassphraseField = UITextField.Style("Encryption passphrase", isSecureTextEntry: true).make()
    private lazy var confirmEncryptionPassphraseField = UITextField.Style("Confirm encryption passphrase", isSecureTextEntry: true).make()
    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel.Style("⚠️ I understand that I'm responsible for securely backing up the encryption passphrase and might suffer permanent loss of all assets if I fail to do so.", numberOfLines: 0).make()
    private lazy var understandsRisksSwitch = UISwitch()
    private lazy var understandsRisksShortLabel: UILabel = "Passhrase is backed up"
    private lazy var riskStackView = UIStackView.Style([understandsRisksSwitch, understandsRisksShortLabel], axis: .horizontal, margin: 0).make()
    private lazy var createNewWalletButton = UIButton.Style("Create New Wallet", isEnabled: false).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        urgeUserToSecurlyBackupPassphraseLabel,
        riskStackView,
        createNewWalletButton,
        .spacer
    ]

    override func setup() {
        understandsRisksSwitch.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - ViewModelled
extension CreateNewWalletView: ViewModelled {

    typealias ViewModel = CreateNewWalletViewModel
    var inputFromView: InputFromView {
        return InputFromView(
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmedNewEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            understandsRisk: understandsRisksSwitch.rx.isOn.asDriver(),
            createWalletTrigger: createNewWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isCreateWalletButtonEnabled --> createNewWalletButton.rx.isEnabled
        ]
    }
}
