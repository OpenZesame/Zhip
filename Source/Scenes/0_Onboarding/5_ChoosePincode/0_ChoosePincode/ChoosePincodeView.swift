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

final class ChoosePincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView           = InputPincodeView()
    private lazy var pinOnlyLocksAppTextView    = UITextView()
    private lazy var doneButton                 = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        pinOnlyLocksAppTextView,
        doneButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ChoosePincodeView: ViewModelled {
    typealias ViewModel = ChoosePincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver(),
            doneTrigger: doneButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ChoosePincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.isDoneButtonEnabled       --> doneButton.rx.isEnabled
        ]
    }
}

private typealias € = L10n.Scene.ChoosePincode
private extension ChoosePincodeView {
    func setupSubviews() {
        pinOnlyLocksAppTextView.withStyle(.nonSelectable) {
            $0.text(€.Text.pincodeOnlyLocksApp).textColor(.silverGrey)
        }

        doneButton.withStyle(.primary) {
            $0.title(€.Button.done)
                .disabled()
        }
    }
}
