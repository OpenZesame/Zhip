//
//  SendView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendView
final class SendView: ScrollingStackView {

    private lazy var walletBalanceView = WalletBalanceView()

    private lazy var recipientAddressField = UITextField.Style("To address", text: "74C544A11795905C2C9808F9E78D8156159D32E4").make()
    private lazy var amountToSendField = UITextField.Style("Amount", text: "11").make()
    private lazy var gasLimitField = UITextField.Style("Gas limit", text: "1").make()
    private lazy var gasPriceField = UITextField.Style("Gas price", text: "1").make()
    private lazy var encryptionPassphrase = UITextField.Style("Wallet Encryption Passphrase", text: "Apabanan").make()
    private lazy var sendButton: UIButton = "Send"
    private lazy var transactionIdentifierLabel: UILabel = "No tx"

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        walletBalanceView,
        recipientAddressField,
        amountToSendField,
        gasLimitField,
        gasPriceField,
        encryptionPassphrase,
        sendButton,
        transactionIdentifierLabel,
        .spacer
    ]
}

// MARK: - SingleContentView
extension SendView: ViewModelled {
    typealias ViewModel = SendViewModel

    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            fetchBalanceTrigger: rx.pullToRefreshTrigger,
            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasPrice: gasPriceField.rx.text.orEmpty.asDriver(),
            passphrase: encryptionPassphrase.rx.text.orEmpty.asDriver(),
            sendTrigger: sendButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isFetchingBalance        --> rx.isRefreshing,
            viewModel.address           --> walletBalanceView.rx.address,
            viewModel.balance           --> walletBalanceView.rx.balance,
            viewModel.nonce           --> walletBalanceView.rx.nonce,
            viewModel.transactionId     --> transactionIdentifierLabel
        ]
    }
}
