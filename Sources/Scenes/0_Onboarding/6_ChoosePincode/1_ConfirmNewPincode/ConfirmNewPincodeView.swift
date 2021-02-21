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

private typealias € = L10n.Scene.ConfirmNewPincode

final class ConfirmNewPincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView               = InputPincodeView(isClearedOnValidInput: false)
    private lazy var haveBackedUpPincodeCheckbox    = CheckboxWithLabel()
    private lazy var confirmPincodeButton           = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        haveBackedUpPincodeCheckbox,
        confirmPincodeButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ConfirmNewPincodeView: ViewModelled {
    typealias ViewModel = ConfirmNewPincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver(),
            isHaveBackedUpPincodeCheckboxChecked: haveBackedUpPincodeCheckbox.rx.isChecked.asDriverOnErrorReturnEmpty(),
            confirmedTrigger: confirmPincodeButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ConfirmNewPincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.pincodeValidation         --> inputPincodeView.rx.validation,
            viewModel.isConfirmPincodeEnabled   --> confirmPincodeButton.rx.isEnabled
        ]
    }
}

private extension ConfirmNewPincodeView {
    func setupSubviews() {

        haveBackedUpPincodeCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.pincodeIsBackedUp)
        }

        confirmPincodeButton.withStyle(.primary) {
            $0.title(€.Button.done)
                .disabled()
        }
    }
}
