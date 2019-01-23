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

private typealias € = L10n.Scene.ConfirmNewPincode

final class ConfirmNewPincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView               = InputPincodeView()
    private lazy var haveBackedUpPincodeCheckbox    = CheckboxWithLabel()
    private lazy var confirmPincodeButton           = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        .spacer,
        haveBackedUpPincodeCheckbox,
        confirmPincodeButton
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
