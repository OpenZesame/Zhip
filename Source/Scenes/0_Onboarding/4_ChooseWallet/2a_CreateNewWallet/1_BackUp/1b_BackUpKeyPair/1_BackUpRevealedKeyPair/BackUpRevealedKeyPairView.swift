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
