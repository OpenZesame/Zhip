//
//  BackUpRevealedKeyPairView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class BackUpRevealedKeyPairView: ScrollingStackView {

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
