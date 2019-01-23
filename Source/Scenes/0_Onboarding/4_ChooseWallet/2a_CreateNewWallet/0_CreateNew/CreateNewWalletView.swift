//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import RxSwift

final class CreateNewWalletView: ScrollableStackViewOwner {

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
