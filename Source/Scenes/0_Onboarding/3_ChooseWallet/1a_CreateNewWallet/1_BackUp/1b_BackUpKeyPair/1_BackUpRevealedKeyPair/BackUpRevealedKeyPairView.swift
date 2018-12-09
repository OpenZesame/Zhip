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

private typealias € = L10n.Scene.BackUpRevealedKeyPair

final class BackUpRevealedKeyPairView: ScrollingStackView {

    private lazy var privateKeyTextView = TitledValueView().titled(€.Label.privateKey)

    private lazy var publicKeyUncompressedTextView = TitledValueView().titled(€.Label.uncompressedPublicKey)

    private lazy var copyPrivateKeyButton = UIButton(title: €.Button.copyPrivateKey)
        .withStyle(.secondary)

    private lazy var copyUncompressedPublicKeyButton = UIButton(title: €.Button.copyPublicKey)
        .withStyle(.secondary)

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyTextView,
        copyPrivateKeyButton,
        publicKeyUncompressedTextView,
        copyUncompressedPublicKeyButton,
        .spacer
    ]

    override func setup() {
        privateKeyTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
