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

    func populate(with viewModel: ViewModel.OutputVM) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> encryptionPasswordField.rx.becomeFirstResponder,
            viewModel.encryptionPasswordValidation    --> encryptionPasswordField.rx.validation,
            viewModel.isSignButtonEnabled               --> signButton.rx.isEnabled,
            viewModel.isSignButtonLoading               --> signButton.rx.isLoading
        ]
    }

    var inputFromView: ViewModel.InputFromView {
        return SignTransactionViewModel.InputFromView(
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
