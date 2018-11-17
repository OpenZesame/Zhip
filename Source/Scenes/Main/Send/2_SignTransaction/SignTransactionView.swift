//
//  SignTransactionView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-17.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.SignTransaction

final class SignTransactionView: ScrollingStackView {

    private lazy var loadingView = SpinnerView()

    private lazy var confirmTransactionLabel = UILabel.Style(€.Label.signTransactionWithEncryptionPassphrase).make()

    private lazy var encryptionPassphraseField = UITextField.Style(€.Field.encryptionPassphrase, isSecureTextEntry: true).make()

    private lazy var confirmButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.confirm)
        .disabled()

    lazy var stackViewStyle: UIStackView.Style = [
        confirmTransactionLabel,
        encryptionPassphraseField,
        confirmButton,
        .spacer
    ]

    override func setup() {
        addSubview(loadingView)
        loadingView.centerInSuperview()
        loadingView.height(200)
        loadingView.width(200)
    }
}

extension SignTransactionView: ViewModelled {
    typealias ViewModel = SignTransactionViewModel

    func populate(with viewModel: SignTransactionViewModel.Output) -> [Disposable] {
        return [
            viewModel.isConfirmButtonEnabled --> confirmButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriverOnErrorReturnEmpty(),
            signAndSendTrigger: confirmButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}
