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

final class RestoreUsingPrivateKeyView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField                        = FloatingLabelTextField()
    private lazy var showPrivateKeyButton = privateKeyField.addBottomAlignedButton(titled: L10n.Generic.show)

    private lazy var encryptionPassphraseField              = FloatingLabelTextField()
    private lazy var confirmEncryptionPassphraseField       = FloatingLabelTextField()

    private let bag = DisposeBag()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            isEditingPrivateKey: privateKeyField.rx.isEditing,
            showPrivateKeyTrigger: showPrivateKeyButton.rx.tap.asDriver(),
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingNewEncryptionPassphrase: encryptionPassphraseField.rx.isEditing,
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingConfirmedEncryptionPassphrase: confirmEncryptionPassphraseField.rx.isEditing
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
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

        encryptionPassphraseField.withStyle(.passphrase)

        confirmEncryptionPassphraseField.withStyle(.passphrase) {
            $0.placeholder(€.Field.confirmEncryptionPassphrase)
        }
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.togglePrivateKeyVisibilityButtonTitle   --> showPrivateKeyButton.rx.title(for: .normal),
            viewModelOutput.privateKeyFieldIsSecureTextEntry        --> privateKeyField.rx.isSecureTextEntry,
            viewModelOutput.encryptionPassphrasePlaceholder         --> encryptionPassphraseField.rx.placeholder,
            viewModelOutput.privateKeyValidation                    --> privateKeyField.rx.validation,
            viewModelOutput.encryptionPassphraseValidation          --> encryptionPassphraseField.rx.validation,
            viewModelOutput.confirmEncryptionPassphraseValidation   --> confirmEncryptionPassphraseField.rx.validation
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
