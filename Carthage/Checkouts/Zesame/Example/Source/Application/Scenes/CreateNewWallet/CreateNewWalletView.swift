//
//  CreateNewWalletView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class CreateNewWalletView: ScrollingStackView {

//    private lazy var walletView = WalletView()
    private lazy var encryptionPassphraseField: UITextField = "Encryption passphrase"
    private lazy var confirmEncryptionPassphraseField: UITextField = "Confirm encryption passphrase"
    private lazy var createNewWalletButton = UIButton.Style("Create New Wallet", isEnabled: false).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
//        walletView,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        createNewWalletButton,
        .spacer
    ]
}

// MARK: - ViewModelled
extension CreateNewWalletView: ViewModelled {
    typealias ViewModel = CreateNewWalletViewModel
    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            encryptionPassphrase: encryptionPassphraseField.rx.text.asDriver(),
            confirmedEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.asDriver(),
            createWalletTrigger: createNewWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isCreateWalletButtonEnabled --> createNewWalletButton.rx.isEnabled
//            viewModel.wallet        --> walletView.rx.wallet
        ]
    }
}
