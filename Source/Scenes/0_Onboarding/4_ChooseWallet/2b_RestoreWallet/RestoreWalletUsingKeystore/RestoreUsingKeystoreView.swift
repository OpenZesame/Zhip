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

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWithKeystoreView
final class RestoreUsingKeystoreView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel

    private let bag = DisposeBag()

    private lazy var keystoreTextView           = UITextView()
    private lazy var encryptionPassphraseField  = FloatingLabelTextField()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            keystoreDidBeginEditing: keystoreTextView.rx.didBeginEditing.asDriver(),
            isEditingKeystore: keystoreTextView.rx.isEditing,
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            isEditingEncryptionPassphrase: encryptionPassphraseField.rx.isEditing
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        encryptionPassphraseField
    ]

    override func setup() {
        setupSubviews()
        setupViewModelBinding()
    }

    func restorationErrorValidation(_ validation: AnyValidation) {
        encryptionPassphraseField.validate(validation)
    }
}

private extension RestoreUsingKeystoreView {

    func setupSubviews() {
        encryptionPassphraseField.withStyle(.passphrase)
        keystoreTextView.withStyle(.editable)
        keystoreTextView.addBorderBy(validation: .empty)
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.keyRestorationValidation            --> keystoreTextView.rx.validationByBorder,
            viewModelOutput.encryptionPassphraseValidation      --> encryptionPassphraseField.rx.validation,
            viewModelOutput.keystoreTextFieldPlaceholder        --> keystoreTextView.rx.text,
            viewModelOutput.encryptionPassphrasePlaceholder     --> encryptionPassphraseField.rx.placeholder
        ]
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: UITextView {
    var validationByBorder: Binder<AnyValidation> {
        return Binder(base) {
            $0.addBorderBy(validation: $1)
        }
    }
}

extension UITextView {
    func addBorderBy(validation: AnyValidation) {
        addBorder(UIView.Border.fromValidation(validation))
    }
}
