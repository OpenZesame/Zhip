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

final class BackUpRevealedKeyPairView: ScrollableStackViewOwner {

    private lazy var privateKeyTextView                 = TitledValueView()
    private lazy var publicKeyUncompressedTextView      = TitledValueView()
    private lazy var copyPrivateKeyButton               = UIButton()
    private lazy var copyPrivateKeyButtonContainer      = UIStackView(arrangedSubviews: [copyPrivateKeyButton, .spacer])
    private lazy var copyUncompressedPublicKeyButton    = UIButton()
    private lazy var copyPublicKeyButtonContainer       = UIStackView(arrangedSubviews: [copyUncompressedPublicKeyButton, .spacer])

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyTextView,
        copyPrivateKeyButtonContainer,
        publicKeyUncompressedTextView,
        copyPublicKeyButtonContainer,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackUpRevealedKeyPairView: ViewModelled {
    typealias ViewModel = BackUpRevealedKeyPairViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.privateKey            --> privateKeyTextView.rx.value,
            viewModel.publicKeyUncompressed --> publicKeyUncompressedTextView.rx.value
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyPrivateKeyTrigger: copyPrivateKeyButton.rx.tap.asDriver(),
            copyPublicKeyTrigger: copyUncompressedPublicKeyButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.BackUpRevealedKeyPair
private extension BackUpRevealedKeyPairView {
    func setupSubviews() {
        privateKeyTextView.withStyles {
            $0.text(€.Label.privateKey)
        }

        privateKeyTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        copyPrivateKeyButton.withStyle(.hollow) {
            $0.title(€.Buttons.copy)
        }

        copyPrivateKeyButtonContainer.withStyle(.horizontal)

        publicKeyUncompressedTextView.withStyles {
            $0.text(€.Label.uncompressedPublicKey)
        }

        copyUncompressedPublicKeyButton.withStyle(.hollow) {
            $0.title(€.Buttons.copy)
        }

        copyPublicKeyButtonContainer.withStyle(.horizontal)

        [copyPrivateKeyButton, copyUncompressedPublicKeyButton].forEach {
            $0.width(136)
        }
    }
}
