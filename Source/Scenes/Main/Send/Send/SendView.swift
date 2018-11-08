//
//  SendView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame


// MARK: - SendView
final class SendView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceView = BalanceView()

    private lazy var recipientAddressField = UITextField.Style("To address", text: "74C544A11795905C2C9808F9E78D8156159D32E4").make()
    private lazy var amountToSendField = UITextField.Style("Amount", text: "11").make()
    private lazy var gasLimitField = UITextField.Style("Gas limit", text: "1").make()
    private lazy var gasPriceField = UITextField.Style("Gas price", text: "1").make()


    private lazy var encryptionPassphraseField = UITextField.Style("Encryption passphrase", isSecureTextEntry: true).make()
    private lazy var sendButton = UIButton.Style("Send", isEnabled: false).make()
    private lazy var transactionIdLabels = LabelsView(titleStyle: "Transaction Id")
    private lazy var openTransactionInfoInBrowserButton = UIButton.Style("Transaction Info", textColor: .white, colorNormal: .blue, isEnabled: false).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        balanceView,
        recipientAddressField,
        amountToSendField,
        gasLimitField,
        gasPriceField,
        encryptionPassphraseField,
        sendButton,
        transactionIdLabels,
        openTransactionInfoInBrowserButton,
        .spacer
    ]
}

// MARK: - SingleContentView
extension SendView: ViewModelled {
    typealias ViewModel = SendViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriver(),
            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasPrice: gasPriceField.rx.text.orEmpty.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver(),
            openTransactionDetailsInBrowserTrigger: openTransactionInfoInBrowserButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.isFetchingBalance         --> rx.isRefreshing,
            viewModel.amount                    --> amountToSendField.rx.text,
            viewModel.recipient                 --> recipientAddressField.rx.text,
            viewModel.isSendButtonEnabled       --> sendButton.rx.isEnabled,
            viewModel.balance                   --> balanceView.rx.balance,
            viewModel.nonce                     --> balanceView.rx.nonce,
            viewModel.isRecipientAddressValid   --> recipientAddressField.rx.isValid,
            viewModel.transactionId             --> transactionIdLabels,
            viewModel.isTxInfoButtonEnabled     --> openTransactionInfoInBrowserButton.rx.isEnabled
        ]
    }
}
