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

final class RestoreUsingPrivateKeyView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField                        = FloatingLabelTextField()
    private lazy var showPrivateKeyButton = privateKeyField.addBottomAlignedButton(titled: L10n.Generic.show)

    private lazy var encryptionPasswordField              = FloatingLabelTextField()
    private lazy var confirmEncryptionPasswordField       = FloatingLabelTextField()

    private let bag = DisposeBag()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            isEditingPrivateKey: privateKeyField.rx.isEditing,
            showPrivateKeyTrigger: showPrivateKeyButton.rx.tap.asDriver(),
            newEncryptionPassword: encryptionPasswordField.rx.text.orEmpty.asDriver(),
            isEditingNewEncryptionPassword: encryptionPasswordField.rx.isEditing,
            confirmEncryptionPassword: confirmEncryptionPasswordField.rx.text.orEmpty.asDriver(),
            isEditingConfirmedEncryptionPassword: confirmEncryptionPasswordField.rx.isEditing
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        encryptionPasswordField,
        confirmEncryptionPasswordField,
        .spacer
    ]

    override func setup() {
        setupSubviews()
        setupViewModelBinding()
    }
}

// MARK: - Private
private typealias € = L10n.Scene.RestoreWallet
private extension RestoreUsingPrivateKeyView {
    func setupSubviews() {
        privateKeyField.withStyle(.privateKey) {
            $0.placeholder(€.Field.privateKey)
        }

        encryptionPasswordField.withStyle(.password)

        confirmEncryptionPasswordField.withStyle(.password) {
            $0.placeholder(€.Field.confirmEncryptionPassword)
        }
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.togglePrivateKeyVisibilityButtonTitle   --> showPrivateKeyButton.rx.title(for: .normal),
            viewModelOutput.privateKeyFieldIsSecureTextEntry        --> privateKeyField.rx.isSecureTextEntry,
            viewModelOutput.encryptionPasswordPlaceholder         --> encryptionPasswordField.rx.placeholder,
            viewModelOutput.privateKeyValidation                    --> privateKeyField.rx.validation,
            viewModelOutput.encryptionPasswordValidation          --> encryptionPasswordField.rx.validation,
            viewModelOutput.confirmEncryptionPasswordValidation   --> confirmEncryptionPasswordField.rx.validation
        ]
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: UITextField {
    var isSecureTextEntry: Binder<Bool> {
        return Binder(base) {
            $0.isSecureTextEntry = $1
        }
    }
}
