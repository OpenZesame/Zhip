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

    private lazy var chooseNewPassphraseLabel = UILabel()

    private lazy var encryptionPassphraseField = TextField(type: .text)
    private lazy var confirmEncryptionPassphraseField = TextField(type: .text)

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel()

    private lazy var understandsRisksCheckbox = CheckboxWithLabel()

    private lazy var createNewWalletButton = ButtonWithSpinner()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        chooseNewPassphraseLabel,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        urgeUserToSecurlyBackupPassphraseLabel,
        understandsRisksCheckbox,
        createNewWalletButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
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
            isUnderstandRisksCheckboxChecked: understandsRisksCheckbox.rx.isChecked.asDriver(),
            createWalletTrigger: createNewWalletButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.CreateNewWallet
private extension CreateNewWalletView {
    func setupSubviews() {
        chooseNewPassphraseLabel.withStyle(.header) {
            $0.text(€.Label.chooseNewPassphrase)
        }

        encryptionPassphraseField.withStyle(.password)

        confirmEncryptionPassphraseField.withStyle(.password) {
            $0.placeholder(€.Field.confirmEncryptionPassphrase)
        }

        urgeUserToSecurlyBackupPassphraseLabel.withStyle(.body) {
            $0.text(€.Label.urgeBackup)
        }

        understandsRisksCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.passphraseIsBackedUp)
        }

        createNewWalletButton.withStyle(.primary) {
            $0.title(€.Button.createNewWallet)
                .disabled()
        }
    }
}
