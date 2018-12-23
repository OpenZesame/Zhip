//
//  RestoreUsingPrivateKeyView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

final class RestoreUsingPrivateKeyView: ScrollingStackView {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField                        = TextField()
    private lazy var encryptionPassphraseField              = TextField()
    private lazy var confirmEncryptionPassphraseField       = TextField()

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
        setupSubviews()
        setupViewModelBinding()
    }
}

// MARK: - Private
private typealias € = L10n.Scene.RestoreWallet
private extension RestoreUsingPrivateKeyView {
    func setupSubviews() {
        privateKeyField.withStyle(.privateKey) {
            $0.placeholder(€.Field.privateKey)
        }

        encryptionPassphraseField.withStyle(.passphrase)

        confirmEncryptionPassphraseField.withStyle(.passphrase) {
            $0.placeholder(€.Field.confirmEncryptionPassphrase)
        }
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.encryptionPassphrasePlaceholder --> encryptionPassphraseField.rx.placeholder
        ]
    }
}
