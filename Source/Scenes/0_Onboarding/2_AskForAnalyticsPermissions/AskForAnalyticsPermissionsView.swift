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

import TinyConstraints
import RxSwift

final class AskForAnalyticsPermissionsView: ScrollableStackViewOwner {

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
extension AskForAnalyticsPermissionsView: ViewModelled {
    typealias ViewModel = AskForAnalyticsPermissionsViewModel

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

private typealias € = L10n.Scene.AskForAnalyticsPermissions
private typealias Icon = Asset.Icons.Large
private extension AskForAnalyticsPermissionsView {
    func setupSubviews() {
        imageView.withStyle(.default) {
            $0.asset(Icon.analytics)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.title)
        }

        disclaimerTextView.withStyle(.nonEditable) {
            $0.text(€.Text.disclaimer)
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
