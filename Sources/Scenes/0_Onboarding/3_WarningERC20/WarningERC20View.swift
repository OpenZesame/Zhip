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

final class WarningERC20View: ScrollableStackViewOwner {

    private lazy var imageView                  = UIImageView()
    private lazy var headerLabel                = UILabel()
    private lazy var warningTextView            = UITextView()
    private lazy var understandCheckbox         = CheckboxWithLabel()
    private lazy var acceptButton               = UIButton()
    private lazy var doNotShowThisAgainButton   = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        warningTextView,
        understandCheckbox,
        acceptButton,
        doNotShowThisAgainButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension WarningERC20View: ViewModelled {
    typealias ViewModel = WarningERC20ViewModel

    func populate(with viewModel: WarningERC20ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isDoNotShowAgainButtonVisible --> doNotShowThisAgainButton.rx.isVisible,
            viewModel.isAcceptButtonCheckboxVisible --> acceptButton.rx.isVisible,
            viewModel.isAcceptButtonCheckboxVisible --> understandCheckbox.rx.isVisible,
            viewModel.isAcceptButtonEnabled         --> acceptButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {

        return InputFromView(
            isUnderstandsERC20IncompatibilityCheckboxChecked: understandCheckbox.rx.isChecked.asDriver(),
            accept: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            doNotShowAgain: doNotShowThisAgainButton.rx.tap.asDriverOnErrorReturnEmpty()
        )

    }
}

private typealias € = L10n.Scene.WarningERC20
private typealias Image = Asset.Icons.Large
private extension WarningERC20View {
    func setupSubviews() {

        imageView.withStyle(.default) {
            $0.image(Image.warning.image)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.Label.erc20Tokens)
        }

        warningTextView.withStyle(.nonEditable) {
            $0.text(€.Text.warningERC20).isSelectable(false)
        }

        understandCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.understandsERC20Incompatibility)
        }

        acceptButton.withStyle(.primary) {
            $0.title(€.Button.accept).disabled()
        }

        doNotShowThisAgainButton.withStyle(.secondary) {
            $0.title(€.Button.doNotShowAgain)
        }
    }
}
