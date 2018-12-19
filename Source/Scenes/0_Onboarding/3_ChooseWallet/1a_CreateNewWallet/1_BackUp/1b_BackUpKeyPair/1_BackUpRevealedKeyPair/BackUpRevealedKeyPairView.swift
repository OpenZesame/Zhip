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
    private lazy var copyUncompressedPublicKeyButton    = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyTextView,
        copyPrivateKeyButton,
        publicKeyUncompressedTextView,
        copyUncompressedPublicKeyButton,
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
        privateKeyTextView.titled(€.Label.privateKey)
        privateKeyTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        publicKeyUncompressedTextView.titled(€.Label.uncompressedPublicKey)

        copyPrivateKeyButton.withStyle(.secondary) {
            $0.title(€.Button.copyPrivateKey)
        }

        copyUncompressedPublicKeyButton.withStyle(.secondary) {
            $0.title(€.Button.copyPublicKey)
        }
    }
}
