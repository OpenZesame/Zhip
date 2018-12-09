//
//  DecryptKeystoreToRevealKeyPairView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.DecryptKeystoreToRevealKeyPair

final class DecryptKeystoreToRevealKeyPairView: ScrollingStackView {

    private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

    private lazy var revealButton: ButtonWithSpinner = ButtonWithSpinner(title: €.Button.reveal)
        .withStyle(.primary) { customizableStyle in
            customizableStyle.disabled()
    }

    lazy var stackViewStyle: UIStackView.Style = [
        encryptionPassphraseField,
        revealButton,
        .spacer
    ]
}

extension DecryptKeystoreToRevealKeyPairView: ViewModelled {
    typealias ViewModel = DecryptKeystoreToRevealKeyPairViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPassphrasePlaceholder   --> encryptionPassphraseField.rx.placeholder,
            viewModel.encryptionPassphraseValidation    --> encryptionPassphraseField.rx.validation,
            viewModel.isRevealButtonLoading             --> revealButton.rx.isLoading,
            viewModel.isRevealButtonEnabled             --> revealButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            revealTrigger: revealButton.rx.tap.asDriver()
        )
    }
}
