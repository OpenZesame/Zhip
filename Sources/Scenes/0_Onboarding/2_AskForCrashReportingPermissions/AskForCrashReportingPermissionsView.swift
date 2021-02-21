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

import TinyConstraints
import RxSwift

final class AskForCrashReportingPermissionsView: ScrollableStackViewOwner {

    private lazy var imageView                      = UIImageView()
    private lazy var headerLabel                    = UILabel()
    private lazy var disclaimerTextView             = UITextView()
    private lazy var hasReadDisclaimerCheckbox      = CheckboxWithLabel()
    private lazy var declineButton                  = UIButton()
    private lazy var acceptButton                   = UIButton()
    private lazy var buttonsStackView               = UIStackView(arrangedSubviews: [declineButton, acceptButton])

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        disclaimerTextView,
        hasReadDisclaimerCheckbox,
        buttonsStackView
    ]

    override func setup() {
        setupSubviews()
    }
}

// MARK: - ViewModelled
extension AskForCrashReportingPermissionsView: ViewModelled {
    typealias ViewModel = AskForCrashReportingPermissionsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.areButtonsEnabled --> declineButton.rx.isEnabled,
            viewModel.areButtonsEnabled --> acceptButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            isHaveReadDisclaimerCheckboxChecked: hasReadDisclaimerCheckbox.rx.isChecked.asDriver(),
            acceptTrigger: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            declineTrigger: declineButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.AskForCrashReportingPermissions
private typealias Icon = Asset.Icons.Large
private extension AskForCrashReportingPermissionsView {
    func setupSubviews() {
        imageView.withStyle(.default) {
            $0.asset(Icon.analytics)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.title)
        }

        disclaimerTextView.withStyle(.nonEditable) {
            $0.text(€.Text.disclaimer).isSelectable(false)
        }

        hasReadDisclaimerCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.readDisclaimer)
        }

        declineButton.withStyle(.primary) {
            $0.title(€.Button.decline)
                .disabled()
        }

        acceptButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }

        buttonsStackView.withStyle(.horizontalFillingEqually)
    }
}
