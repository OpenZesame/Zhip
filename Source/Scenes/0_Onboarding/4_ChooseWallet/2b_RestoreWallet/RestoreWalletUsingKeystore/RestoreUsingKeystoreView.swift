//
//  RestoreUsingKeystoreView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWithKeystoreView
final class RestoreUsingKeystoreView: BaseSceneView {
    typealias ViewModel = RestoreWalletUsingKeystoreViewModel

    private let bag = DisposeBag()

    private lazy var keystoreTextView           = UITextView()
    private lazy var encryptionPassphraseField  = FloatingLabelTextField()

    private lazy var viewModel = ViewModel(
        inputFromView: ViewModel.InputFromView(
            keystoreDidBeginEditing: keystoreTextView.rx.didBeginEditing.asDriver(),
            isEditingKeystore: keystoreTextView.rx.isEditing,
            keystoreText: keystoreTextView.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            isEditingEncryptionPassphrase: encryptionPassphraseField.rx.isEditing
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

    func restorationErrorValidation(_ validation: AnyValidation) {
        encryptionPassphraseField.validate(validation)
    }
}

private extension RestoreUsingKeystoreView {

    func setupSubviews() {
        encryptionPassphraseField.withStyle(.passphrase)
        keystoreTextView.withStyle(.editable)
        keystoreTextView.addBorderBy(validation: .empty)
    }

    func setupViewModelBinding() {
        bag <~ [
            viewModelOutput.keyRestorationValidation            --> keystoreTextView.rx.validationByBorder,
            viewModelOutput.encryptionPassphraseValidation      --> encryptionPassphraseField.rx.validation,
            viewModelOutput.keystoreTextFieldPlaceholder        --> keystoreTextView.rx.text,
            viewModelOutput.encryptionPassphrasePlaceholder     --> encryptionPassphraseField.rx.placeholder
        ]
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: UITextView {
    var validationByBorder: Binder<AnyValidation> {
        return Binder(base) {
            $0.addBorderBy(validation: $1)
        }
    }
}

extension UITextView {
    func addBorderBy(validation: AnyValidation) {
        addBorder(UIView.Border.fromValidation(validation))
    }
}
