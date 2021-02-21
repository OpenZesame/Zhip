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

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWithKeystoreView
final class RestoreUsingKeystoreView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel

    private let bag = DisposeBag()

    private lazy var keystoreTextView           = UITextView()
    private lazy var encryptionPasswordField  = FloatingLabelTextField()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            keystoreDidBeginEditing: keystoreTextView.rx.didBeginEditing.asDriver(),
            isEditingKeystore: keystoreTextView.rx.isEditing,
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassword: encryptionPasswordField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            isEditingEncryptionPassword: encryptionPasswordField.rx.isEditing
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        encryptionPasswordField
    ]

    override func setup() {
        setupSubviews()
        setupViewModelBinding()
    }

    func restorationErrorValidation(_ validation: AnyValidation) {
        encryptionPasswordField.validate(validation)
    }
}

private extension RestoreUsingKeystoreView {

    func setupSubviews() {
        encryptionPasswordField.withStyle(.password)
        keystoreTextView.withStyle(.editable)
        keystoreTextView.addBorderBy(validation: .empty)
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.keyRestorationValidation            --> keystoreTextView.rx.validationByBorder,
            viewModelOutput.encryptionPasswordValidation      --> encryptionPasswordField.rx.validation,
            viewModelOutput.keystoreTextFieldPlaceholder        --> keystoreTextView.rx.text,
            viewModelOutput.encryptionPasswordPlaceholder     --> encryptionPasswordField.rx.placeholder
        ]
    }
}

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
