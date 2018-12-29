//
//  RestoreUsingKeystoreView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWithKeystoreView
final class RestoreUsingKeystoreView: ScrollingStackView {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel

    private let bag = DisposeBag()

    private lazy var keystoreTextView           = UITextView()
    private lazy var encryptionPassphraseField  = FloatingLabelTextField()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            keystoreDidBeginEditing: keystoreTextView.rx.didBeginEditing.asDriver(),
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged()
        )
    )

    lazy var viewModelOutput = viewModel.output

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        encryptionPassphraseField
    ]

    override func setup() {
        setupSubviews()
        setupViewModelBinding()
    }
}

private extension RestoreUsingKeystoreView {

    func setupSubviews() {
        encryptionPassphraseField.withStyle(.passphrase)
        keystoreTextView.withStyle(.editable)
        keystoreTextView.addBorder(Border(color: .teal))
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.keystoreTextFieldPlaceholder     --> keystoreTextView.rx.text,
            viewModelOutput.encryptionPassphrasePlaceholder --> encryptionPassphraseField.rx.placeholder
        ]
    }
}
