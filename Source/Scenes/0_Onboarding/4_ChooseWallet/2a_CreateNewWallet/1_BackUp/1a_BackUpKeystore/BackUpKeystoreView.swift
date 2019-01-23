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

final class BackUpKeystoreView: ScrollableStackViewOwner {

    private lazy var keystoreTextView   = UITextView()
    private lazy var copyButton         = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        copyButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackUpKeystoreView: ViewModelled {
    typealias ViewModel = BackUpKeystoreViewModel

    func populate(with viewModel: BackUpKeystoreViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystore --> keystoreTextView.rx.text
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyTrigger: copyButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.BackUpKeystore
private extension BackUpKeystoreView {
    func setupSubviews() {
        keystoreTextView.withStyle(.nonEditable) {
            $0.textAlignment(.left)
        }

        copyButton.withStyle(.primary) {
            $0.title(€.Button.copy)
        }
    }
}
