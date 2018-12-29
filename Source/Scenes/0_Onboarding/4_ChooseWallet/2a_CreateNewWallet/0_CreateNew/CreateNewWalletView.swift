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

    private lazy var headerLabel                        = UILabel()
    private lazy var subtitleLabel                      = UILabel()
    private lazy var encryptionPassphraseField          = FloatingLabelTextField()
    private lazy var confirmEncryptionPassphraseField   = FloatingLabelTextField()
    private lazy var haveBackedUpPassphraseCheckbox     = CheckboxWithLabel()
    private lazy var continueButton                     = ButtonWithSpinner()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        headerLabel,
        subtitleLabel,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        .spacer,
        haveBackedUpPassphraseCheckbox,
        continueButton
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
            viewModel.encryptionPassphrasePlaceholder       --> encryptionPassphraseField.rx.placeholder,
            viewModel.encryptionPassphraseValidation        --> encryptionPassphraseField.rx.validation,
            viewModel.confirmEncryptionPassphraseValidation --> confirmEncryptionPassphraseField.rx.validation,
            viewModel.isContinueButtonEnabled               --> continueButton.rx.isEnabled,
            viewModel.isButtonLoading                       --> continueButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingNewEncryptionPassphrase: encryptionPassphraseField.rx.isEditing,
            
            confirmedNewEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingConfirmedEncryptionPassphrase: confirmEncryptionPassphraseField.rx.isEditing,
            isHaveBackedUpPassphraseCheckboxChecked: haveBackedUpPassphraseCheckbox.rx.isChecked.asDriver(),
            createWalletTrigger: continueButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.CreateNewWallet
private extension CreateNewWalletView {
    func setupSubviews() {
        headerLabel.withStyle(.header) {
            $0.text(€.Labels.ChooseNewPassphrase.title)
        }

        subtitleLabel.withStyle(.body) {
            $0.text(€.Labels.ChooseNewPassphrase.value)
        }

        encryptionPassphraseField.withStyle(.passphrase)

        confirmEncryptionPassphraseField.withStyle(.passphrase) {
            $0.placeholder(€.Field.confirmEncryptionPassphrase)
        }

        haveBackedUpPassphraseCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.passphraseIsBackedUp)
        }

        continueButton.withStyle(.primary) {
            $0.title(€.Button.continue)
                .disabled()
        }
    }
}
