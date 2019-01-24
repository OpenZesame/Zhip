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
    private lazy var encryptionPasswordField      = FloatingLabelTextField()
    private lazy var signButton                     = ButtonWithSpinner()

    lazy var stackViewStyle: UIStackView.Style = [
        confirmTransactionLabel,
        encryptionPasswordField,
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
            viewModel.inputBecomeFirstResponder --> encryptionPasswordField.rx.becomeFirstResponder,
            viewModel.encryptionPasswordValidation    --> encryptionPasswordField.rx.validation,
            viewModel.isSignButtonEnabled               --> signButton.rx.isEnabled,
            viewModel.isSignButtonLoading               --> signButton.rx.isLoading
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassword: encryptionPasswordField.rx.text.orEmpty.asDriverOnErrorReturnEmpty(),
            isEditingEncryptionPassword: encryptionPasswordField.rx.isEditing,
            signAndSendTrigger: signButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.SignTransaction
private extension SignTransactionView {
    func setupSubviews() {
        confirmTransactionLabel.withStyle(.body) {
            $0.text(€.Label.signTransactionWithEncryptionPassword)
        }

        encryptionPasswordField.withStyle(.password) {
            $0.placeholder(€.Field.encryptionPassword)
        }

        signButton.withStyle(.primary) {
            $0.title(€.Button.confirm)
                .disabled()
        }
    }
}
