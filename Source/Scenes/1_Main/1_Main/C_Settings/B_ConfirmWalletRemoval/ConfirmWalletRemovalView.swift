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

final class ConfirmWalletRemovalView: ScrollableStackViewOwner {

    private lazy var areYouSureLabel = UILabel()

    private lazy var haveBackedUpWalletCheckbox = CheckboxWithLabel()

    private lazy var confirmButton = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        areYouSureLabel,
        .spacer,
        haveBackedUpWalletCheckbox,
        confirmButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ConfirmWalletRemovalView: ViewModelled {
    typealias ViewModel = ConfirmWalletRemovalViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isConfirmButtonEnabled --> confirmButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            confirmTrigger: confirmButton.rx.tap.asDriverOnErrorReturnEmpty(),
            isWalletBackedUpCheckboxChecked: haveBackedUpWalletCheckbox.rx.isChecked.asDriver()
        )
    }
}

private typealias € = L10n.Scene.ConfirmWalletRemoval
private extension ConfirmWalletRemovalView {
    func setupSubviews() {
        areYouSureLabel.withStyle(.header) {
            $0.text(€.Label.areYouSure)
        }

        haveBackedUpWalletCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.backUpWallet)
        }

        confirmButton.withStyle(.primary) {
            $0.title(€.Button.confirm)
                .disabled()
        }
    }
}
