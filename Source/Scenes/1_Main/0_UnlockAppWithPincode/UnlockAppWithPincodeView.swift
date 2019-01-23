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

private typealias € = L10n.Scene.UnlockAppWithPincode

final class UnlockAppWithPincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView = InputPincodeView()
    private lazy var descriptionLabel = UILabel()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        descriptionLabel,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension UnlockAppWithPincodeView: ViewModelled {
    typealias ViewModel = UnlockAppWithPincodeViewModel

    func populate(with viewModel: UnlockAppWithPincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.pincodeValidation         --> inputPincodeView.rx.validation
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver()
        )
    }
}

private extension UnlockAppWithPincodeView {
    func setupSubviews() {

        descriptionLabel.withStyle(.body) {
            $0.text(€.label).textAlignment(.center)
        }
    }
}
