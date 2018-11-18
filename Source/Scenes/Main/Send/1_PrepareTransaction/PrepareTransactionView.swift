//
//  PrepareTransactionView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.PrepareTransaction

// MARK: - PrepareTransactionView
final class PrepareTransactionView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceLabels = LabelsView(title: €.Labels.Balance.title)

    private lazy var recipientAddressField = UITextField.Style(€.Field.recipient, text: "74C544A11795905C2C9808F9E78D8156159D32E4").make()

    private lazy var amountToSendField = UITextField.Style(€.Field.amount, text: "11").make()

    private lazy var gasPriceField = UITextField.Style(€.Field.gasPrice, text: "1").make()
    private lazy var gasLimitField = UITextField.Style(€.Field.gasLimit, text: "1").make()

    private lazy var gasFields = UIStackView.Style([gasPriceField, gasLimitField], axis: .horizontal, distribution: .fillEqually, margin: 0).make()

    private lazy var sendButton = UIButton().withStyle(.primary)
        .titled(normal: €.Button.send)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        balanceLabels,
        recipientAddressField,
        amountToSendField,
        gasFields,
        .spacer,
        sendButton
    ]
}

// MARK: - SingleContentView
extension PrepareTransactionView: ViewModelled {
    typealias ViewModel = PrepareTransactionViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriver(),
            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasPrice: gasPriceField.rx.text.orEmpty.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.isFetchingBalance         --> rx.isRefreshing,
            viewModel.amount                    --> amountToSendField.rx.text,
            viewModel.recipient                 --> recipientAddressField.rx.text,
            viewModel.isSendButtonEnabled       --> sendButton.rx.isEnabled,
            viewModel.balance                   --> balanceLabels.rx.value,
            viewModel.isRecipientAddressValid   --> recipientAddressField.rx.isValid
        ]
    }
}
