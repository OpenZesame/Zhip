//
//  RestoreUsingPrivateKeyView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

final class RestoreUsingPrivateKeyView: ScrollingStackView {
    typealias ViewModel = RestoreWalletUsingPrivateKeyViewModel

    private lazy var privateKeyField                        = FloatingLabelTextField()
    private lazy var showPrivateKeyButton = privateKeyField.addBottomAlignedButton(titled: L10n.Generic.show)

    private lazy var encryptionPassphraseField              = FloatingLabelTextField()
    private lazy var confirmEncryptionPassphraseField       = FloatingLabelTextField()

    private let bag = DisposeBag()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            isEditingPrivateKey: privateKeyField.rx.isEditing,
            showPrivateKeyTrigger: showPrivateKeyButton.rx.tap.asDriver(),
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingNewEncryptionPassphrase: encryptionPassphraseField.rx.isEditing,
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            isEditingConfirmedEncryptionPassphrase: confirmEncryptionPassphraseField.rx.isEditing
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
            viewModelOutput.togglePrivateKeyVisibilityButtonTitle   --> showPrivateKeyButton.rx.title(for: .normal),
            viewModelOutput.privateKeyFieldIsSecureTextEntry        --> privateKeyField.rx.isSecureTextEntry,
            viewModelOutput.encryptionPassphrasePlaceholder         --> encryptionPassphraseField.rx.placeholder,
            viewModelOutput.privateKeyValidation                    --> privateKeyField.rx.validation,
            viewModelOutput.encryptionPassphraseValidation          --> encryptionPassphraseField.rx.validation,
            viewModelOutput.confirmEncryptionPassphraseValidation   --> confirmEncryptionPassphraseField.rx.validation
        ]
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: UITextField {
    var isSecureTextEntry: Binder<Bool> {
        return Binder(base) {
            $0.isSecureTextEntry = $1
        }
    }
}
