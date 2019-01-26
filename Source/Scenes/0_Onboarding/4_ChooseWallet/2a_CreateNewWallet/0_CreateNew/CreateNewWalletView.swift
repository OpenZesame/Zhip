// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
