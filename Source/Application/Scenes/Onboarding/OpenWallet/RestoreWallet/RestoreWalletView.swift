//
//  RestoreWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class RestoreWalletView: ScrollingStackView {

    private lazy var privateKeyField = UITextField.Style("Private key", isSecureTextEntry: true).make()
    private lazy var keystoreLabel: UILabel = "Or paste keystore (JSON) below"
    private lazy var keystoreTextView = UITextView.Style("", height: 50).make()
    private lazy var encryptionPassphraseField = UITextField.Style("Encryption passphrase", isSecureTextEntry: true).make()
    private lazy var confirmEncryptionPassphraseField = UITextField.Style("Confirm encryption passphrase", isSecureTextEntry: true).make()
    private lazy var restoreWalletButton = UIButton.Style("Restore Wallet", isEnabled: false).make()

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        keystoreLabel,
        keystoreTextView,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        restoreWalletButton,
        .spacer
    ]

    override func setup() {
        keystoreTextView.addBorder()
    }
}

//protocol Validatable: AnyObject {
//
//}
//
//class Validator {
//    private weak var validatable: Validatable?
//    init(validatable: Validatable) {
//        self.validatable = validatable
//    }
//}

import SwiftValidator

struct ValidationErrors {
    let errors: [(UIView & Validatable, ValidationError)]
}

import RxCocoa
extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var inputFromView: InputFromView {

        let validator = Validator()
        validator.registerField(encryptionPassphraseField, rules: [RequiredRule(), MinLengthRule(length: 9)])
        validator.registerField(confirmEncryptionPassphraseField, rules: [ConfirmationRule(confirmField: encryptionPassphraseField)])

        return InputFromView(
            validator: validator,
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: RestoreWalletViewModel.Output) -> [Disposable] {
        return [
            viewModel.isRestoreButtonEnabled --> restoreWalletButton.rx.isEnabled
        ]
    }

    var errorBinder: Binder<ValidationErrors> {
        return Binder<ValidationErrors>(self) {
            $0.markFieldInvalids(errors: $1)
        }
    }
}

private extension RestoreWalletView {
    func markFieldInvalids(errors: ValidationErrors) {
        for (view, error) in errors.errors {
            view.addBorder(.error)
            print("🚨 error in input: \(error)")
//            error.errorLabel?.text = error.errorMessage // works if you added labels
//            error.errorLabel?.isHidden = false
        }
    }
}
