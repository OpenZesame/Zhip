//
//  RestoreUsingPrivateKeyView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWithPrivateKeyView
final class RestoreUsingPrivateKeyView: ScrollingStackView {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField = TextField(placeholder: €.Field.privateKey, type: .hexadecimal)
        .withStyle(.password)
    private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

    private lazy var confirmEncryptionPassphraseField = TextField(placeholder: €.Field.confirmEncryptionPassphrase, type: .text).withStyle(.password)

    private let bag = DisposeBag()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged()
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        .spacer
    ]

    override func setup() {
        setupViewModelBinding()
    }

    private func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.encryptionPassphrasePlaceholder --> encryptionPassphraseField.rx.placeholder
        ]
    }
}
