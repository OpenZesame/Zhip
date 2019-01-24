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
    private lazy var encryptionPasswordField          = FloatingLabelTextField()
    private lazy var confirmEncryptionPasswordField   = FloatingLabelTextField()
    private lazy var haveBackedUpPasswordCheckbox     = CheckboxWithLabel()
    private lazy var continueButton                     = ButtonWithSpinner()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        headerLabel,
        subtitleLabel,
        encryptionPasswordField,
        confirmEncryptionPasswordField,
        .spacer,
        haveBackedUpPasswordCheckbox,
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
            viewModel.encryptionPasswordPlaceholder       --> encryptionPasswordField.rx.placeholder,
            viewModel.encryptionPasswordValidation        --> encryptionPasswordField.rx.validation,
            viewModel.confirmEncryptionPasswordValidation --> confirmEncryptionPasswordField.rx.validation,
            viewModel.isContinueButtonEnabled               --> continueButton.rx.isEnabled,
            viewModel.isButtonLoading                       --> continueButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            newEncryptionPassword: encryptionPasswordField.rx.text.orEmpty.asDriver(),
            isEditingNewEncryptionPassword: encryptionPasswordField.rx.isEditing,
            
            confirmedNewEncryptionPassword: confirmEncryptionPasswordField.rx.text.orEmpty.asDriver(),
            isEditingConfirmedEncryptionPassword: confirmEncryptionPasswordField.rx.isEditing,
            isHaveBackedUpPasswordCheckboxChecked: haveBackedUpPasswordCheckbox.rx.isChecked.asDriver(),
            createWalletTrigger: continueButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.CreateNewWallet
private extension CreateNewWalletView {
    func setupSubviews() {
        headerLabel.withStyle(.header) {
            $0.text(€.Labels.ChooseNewPassword.title)
        }

        subtitleLabel.withStyle(.body) {
            $0.text(€.Labels.ChooseNewPassword.value)
        }

        encryptionPasswordField.withStyle(.password)

        confirmEncryptionPasswordField.withStyle(.password) {
            $0.placeholder(€.Field.confirmEncryptionPassword)
        }

        haveBackedUpPasswordCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.passwordIsBackedUp)
        }

        continueButton.withStyle(.primary) {
            $0.title(€.Button.continue)
                .disabled()
        }
    }
}
