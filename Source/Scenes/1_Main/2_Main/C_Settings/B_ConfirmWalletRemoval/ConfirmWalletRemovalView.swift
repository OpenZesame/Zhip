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
