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
        .spacer,
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
            viewModel.isAcceptButtonEnabled         --> acceptButton.rx.isEnabled,
            viewModel.isDoNotShowAgainButtonVisible --> doNotShowThisAgainButton.rx.isVisible
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
            $0.text(€.Text.warningERC20)
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
