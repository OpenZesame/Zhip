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
import RxCocoa

final class SignTransactionView: ScrollableStackViewOwner {

    private lazy var confirmTransactionLabel        = UILabel()
    private lazy var encryptionPassphraseField      = FloatingLabelTextField()
    private lazy var signButton                     = ButtonWithSpinner()

    lazy var stackViewStyle: UIStackView.Style = [
        confirmTransactionLabel,
        encryptionPassphraseField,
        signButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension SignTransactionView: ViewModelled {
    typealias ViewModel = SignTransactionViewModel

    func populate(with viewModel: SignTransactionViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> encryptionPassphraseField.rx.becomeFirstResponder,
            viewModel.encryptionPassphraseValidation    --> encryptionPassphraseField.rx.validation,
            viewModel.isSignButtonEnabled               --> signButton.rx.isEnabled,
            viewModel.isSignButtonLoading               --> signButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriverOnErrorReturnEmpty(),
            isEditingEncryptionPassphrase: encryptionPassphraseField.rx.isEditing,
            signAndSendTrigger: signButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.SignTransaction
private extension SignTransactionView {
    func setupSubviews() {
        confirmTransactionLabel.withStyle(.body) {
            $0.text(€.Label.signTransactionWithEncryptionPassphrase)
        }

        encryptionPassphraseField.withStyle(.passphrase) {
            $0.placeholder(€.Field.encryptionPassphrase)
        }

        signButton.withStyle(.primary) {
            $0.title(€.Button.confirm)
                .disabled()
        }
    }
}
