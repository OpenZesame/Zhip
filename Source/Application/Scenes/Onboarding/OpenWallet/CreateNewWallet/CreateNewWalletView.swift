//
//  CreateNewWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class CreateNewWalletView: ScrollingStackView {

    private lazy var encryptionPassphraseField = UITextField.Style("Encryption passphrase", text: "apabanan").make()
    private lazy var confirmEncryptionPassphraseField = UITextField.Style("Confirm encryption passphrase", text: "apabanan").make()
    private lazy var createNewWalletButton = UIButton.Style("Create New Wallet", isEnabled: false).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        createNewWalletButton,
        .spacer
    ]
}

// MARK: - ViewModelled
extension CreateNewWalletView: ViewModelled {

    typealias ViewModel = CreateNewWalletViewModel
    var userInput: UserInput {
        return UserInput(
            newEncryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            confirmedNewEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.orEmpty.asDriver(),
            createWalletTrigger: createNewWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isCreateWalletButtonEnabled --> createNewWalletButton.rx.isEnabled
        ]
    }
}
