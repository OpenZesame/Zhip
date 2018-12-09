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

    private lazy var keystoreTextView = UITextView(frame: .zero).withStyle(.editable)

    private lazy var encryptionPassphraseField = TextField(type: .text).withStyle(.password)

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
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
        setupTextView()
        setupViewModelBinding()
    }
}

private extension RestoreUsingKeystoreView {
    func setupTextView() {
        keystoreTextView.addBorder()
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.encryptionPassphrasePlaceholder --> encryptionPassphraseField.rx.placeholder
        ]
    }
}
