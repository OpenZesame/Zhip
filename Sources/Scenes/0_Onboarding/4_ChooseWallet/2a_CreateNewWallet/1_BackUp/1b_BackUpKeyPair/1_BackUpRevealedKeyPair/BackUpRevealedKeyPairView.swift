//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

final class BackUpRevealedKeyPairView: ScrollableStackViewOwner {
    private lazy var privateKeyTextView = TitledValueView()
    private lazy var publicKeyUncompressedTextView = TitledValueView()
    private lazy var copyPrivateKeyButton = UIButton()
    private lazy var copyPrivateKeyButtonContainer = UIStackView(arrangedSubviews: [copyPrivateKeyButton, .spacer])
    private lazy var copyUncompressedPublicKeyButton = UIButton()
    private lazy var copyPublicKeyButtonContainer = UIStackView(arrangedSubviews: [
        copyUncompressedPublicKeyButton,
        .spacer,
    ])

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyTextView,
        copyPrivateKeyButtonContainer,
        publicKeyUncompressedTextView,
        copyPublicKeyButtonContainer,
        .spacer,
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackUpRevealedKeyPairView: ViewModelled {
    typealias ViewModel = BackUpRevealedKeyPairViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        [
            viewModel.privateKey --> privateKeyTextView.rx.value,
            viewModel.publicKeyUncompressed --> publicKeyUncompressedTextView.rx.value,
        ]
    }

    var inputFromView: InputFromView {
        InputFromView(
            copyPrivateKeyTrigger: copyPrivateKeyButton.rx.tap,
            copyPublicKeyTrigger: copyUncompressedPublicKeyButton.rx.tap
        )
    }
}

private extension BackUpRevealedKeyPairView {
    func setupSubviews() {
        privateKeyTextView.withStyles {
            $0.text(String(localized: .BackUpRevealedKeyPair.privateKeyLabel))
        }

        privateKeyTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        copyPrivateKeyButton.withStyle(.hollow) {
            $0.title(String(localized: .BackUpRevealedKeyPair.copy))
        }

        copyPrivateKeyButtonContainer.withStyle(.horizontal)

        publicKeyUncompressedTextView.withStyles {
            $0.text(String(localized: .BackUpRevealedKeyPair.uncompressedPublicKey))
        }

        copyUncompressedPublicKeyButton.withStyle(.hollow) {
            $0.title(String(localized: .BackUpRevealedKeyPair.copy))
        }

        copyPublicKeyButtonContainer.withStyle(.horizontal)

        for item in [copyPrivateKeyButton, copyUncompressedPublicKeyButton] {
            item.width(136)
        }
    }
}
