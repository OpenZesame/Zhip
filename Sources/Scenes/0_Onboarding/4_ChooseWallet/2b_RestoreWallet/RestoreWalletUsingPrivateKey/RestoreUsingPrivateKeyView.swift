//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import UIKit

final class RestoreUsingPrivateKeyView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField = FloatingLabelTextField()
    private lazy var showPrivateKeyButton = privateKeyField
        .addBottomAlignedButton(titled: String(localized: .Generic.show))

    private lazy var encryptionPasswordField = FloatingLabelTextField()
    private lazy var confirmEncryptionPasswordField = FloatingLabelTextField()

    private var cancellables = Set<AnyCancellable>()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            privateKey: privateKeyField.textPublisher.orEmpty,
            isEditingPrivateKey: privateKeyField.isEditingPublisher,
            showPrivateKeyTrigger: showPrivateKeyButton.tapPublisher,
            newEncryptionPassword: encryptionPasswordField.textPublisher.orEmpty,
            isEditingNewEncryptionPassword: encryptionPasswordField.isEditingPublisher,
            confirmEncryptionPassword: confirmEncryptionPasswordField.textPublisher.orEmpty,
            isEditingConfirmedEncryptionPassword: confirmEncryptionPasswordField.isEditingPublisher
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        encryptionPasswordField,
        confirmEncryptionPasswordField,
        .spacer,
    ]

    override func setup() {
        setupSubviews()
        setupViewModelBinding()
    }
}

// MARK: - Private

private extension RestoreUsingPrivateKeyView {
    func setupSubviews() {
        privateKeyField.withStyle(.privateKey) {
            $0.placeholder(String(localized: .RestoreWallet.privateKeyField))
        }

        encryptionPasswordField.withStyle(.password)

        confirmEncryptionPasswordField.withStyle(.password) {
            $0.placeholder(String(localized: .RestoreWallet.confirmEncryptionPassword))
        }
    }

    func setupViewModelBinding() {
        let showPrivateKeyButtonTitleBinder = Binder<String>(showPrivateKeyButton) { button, title in
            button.setTitle(title, for: .normal)
        }
        [
            viewModelOutput.togglePrivateKeyVisibilityButtonTitle --> showPrivateKeyButtonTitleBinder,
            viewModelOutput.privateKeyFieldIsSecureTextEntry --> privateKeyField.isSecureTextEntryBinder,
            viewModelOutput.encryptionPasswordPlaceholder --> encryptionPasswordField.placeholderBinder,
            viewModelOutput.privateKeyValidation --> privateKeyField.validationBinder,
            viewModelOutput.encryptionPasswordValidation --> encryptionPasswordField.validationBinder,
            viewModelOutput.confirmEncryptionPasswordValidation --> confirmEncryptionPasswordField.validationBinder,
        ].forEach { $0.store(in: &cancellables) }
    }
}

extension UITextField {
    var isSecureTextEntryBinder: Binder<Bool> {
        Binder(self) {
            $0.isSecureTextEntry = $1
        }
    }
}
