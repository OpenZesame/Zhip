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

    private lazy var chooseNewPassphraseLabel = UILabel(text: €.Label.chooseNewPassphrase).withStyle(.title)

    private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)
    private lazy var confirmEncryptionPassphraseField = TextField(placeholder: €.Field.confirmEncryptionPassphrase, type: .text).withStyle(.password)

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel(text: €.Label.urgeBackup).withStyle(.body)

    private lazy var understandsRisksCheckbox = CheckboxWithLabel(titled: €.Checkbox.passphraseIsBackedUp)

    private lazy var createNewWalletButton: ButtonWithSpinner = ButtonWithSpinner(title: €.Button.createNewWallet)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
        }

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
