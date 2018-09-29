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

    private lazy var walletView = WalletView()
    private lazy var emailForKeystoreBackupField: UITextField = "Email for keystore backup"
    private lazy var sendBackupButton: UIButton = "Send keystore backup "

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        walletView,
        emailForKeystoreBackupField,
        sendBackupButton,
        .spacer
    ]
}

// MARK: - ViewModelled
extension CreateNewWalletView: ViewModelled {
    typealias ViewModel = CreateNewWalletViewModel
    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            emailAddress: emailForKeystoreBackupField.rx.text.asDriverOnErrorReturnEmpty(),
            sendBackupTrigger: sendBackupButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.canSendBackup --> sendBackupButton.rx.isEnabled,
            viewModel.wallet        --> walletView.rx.wallet
        ]
    }
}
