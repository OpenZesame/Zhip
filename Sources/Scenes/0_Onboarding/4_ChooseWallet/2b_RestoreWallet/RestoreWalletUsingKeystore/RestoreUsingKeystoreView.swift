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

// MARK: - RestoreWithKeystoreView

final class RestoreUsingKeystoreView: ScrollableStackViewOwner {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel

    private var cancellables = Set<AnyCancellable>()

    private lazy var keystoreTextView = UITextView()
    private lazy var encryptionPasswordField = FloatingLabelTextField()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            keystoreDidBeginEditing: keystoreTextView.didBeginEditingPublisher,
            isEditingKeystore: keystoreTextView.isEditingPublisher,
            keystoreText: keystoreTextView.textPublisher.orEmpty.removeDuplicates().eraseToAnyPublisher(),
            encryptionPassword: encryptionPasswordField.textPublisher.orEmpty.removeDuplicates().eraseToAnyPublisher(),
            isEditingEncryptionPassword: encryptionPasswordField.isEditingPublisher
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        encryptionPasswordField,
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
        [
            viewModelOutput.keyRestorationValidation --> keystoreTextView.validationBorderBinder,
            viewModelOutput.encryptionPasswordValidation --> encryptionPasswordField.validationBinder,
            viewModelOutput.keystoreTextFieldPlaceholder --> keystoreTextView.textBinder,
            viewModelOutput.encryptionPasswordPlaceholder --> encryptionPasswordField.placeholderBinder,
        ].forEach { $0.store(in: &cancellables) }
    }
}

extension UITextView {
    var validationBorderBinder: Binder<AnyValidation> {
        Binder(self) {
            $0.addBorderBy(validation: $1)
        }
    }
}

extension UITextView {
    func addBorderBy(validation: AnyValidation) {
        addBorder(UIView.Border.fromValidation(validation))
    }
}
