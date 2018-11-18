//
//  CreateNewWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.CreateNewWallet

final class CreateNewWalletView: ScrollingStackView {

    private lazy var chooseNewPassphraseLabel = UILabel.Style(€.Label.chooseNewPassphrase).make()
    private lazy var encryptionPassphraseField = UITextField.Style(isSecureTextEntry: true).make()
    private lazy var confirmEncryptionPassphraseField = UITextField.Style(€.Field.confirmEncryptionPassphrase, isSecureTextEntry: true).make()
    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel.Style(€.Label.urgeBackup, numberOfLines: 0).make()
    private lazy var understandsRisksSwitch = UISwitch()
    private lazy var understandsRisksShortLabel = UILabel.Style(€.SwitchLabel.passphraseIsBackedUp).make()
    private lazy var riskStackView = UIStackView.Style([understandsRisksSwitch, understandsRisksShortLabel], axis: .horizontal, margin: 0).make()

    private lazy var createNewWalletButton: ButtonWithSpinner = ButtonWithSpinner(style: .primary)
        .titled(normal: €.Button.createNewWallet)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        chooseNewPassphraseLabel,
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

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPassphrasePlaceholder   --> encryptionPassphraseField.rx.placeholder,
            viewModel.isCreateWalletButtonEnabled       --> createNewWalletButton.rx.isEnabled,
            viewModel.isButtonLoading                   --> createNewWalletButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmedNewEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            understandsRisk: understandsRisksSwitch.rx.isOn.asDriver(),
            createWalletTrigger: createNewWalletButton.rx.tap.asDriver()
        )
    }
}
