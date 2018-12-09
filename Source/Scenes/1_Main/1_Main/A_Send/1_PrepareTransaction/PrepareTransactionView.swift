//
//  PrepareTransactionView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import Zesame

import RxSwift
import RxCocoa

import SkyFloatingLabelTextField
import Validator

private typealias € = L10n.Scene.PrepareTransaction

// MARK: - PrepareTransactionView
final class PrepareTransactionView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceLabels = TitledValueView()
        .titled(€.Labels.Balance.title)

    private lazy var recipientAddressField = TextField(placeholder: €.Field.recipient, type: .hexadecimal)
        .withStyle(.default)

    private lazy var amountToSendField = TextField(placeholder: €.Field.amount, type: .decimal)
        .withStyle(.decimal)

    private lazy var gasPriceField = TextField(placeholder: €.Field.gasPrice, type: .decimal)
        .withStyle(.decimal)

    private lazy var gasLimitField = TextField(placeholder: €.Field.gasLimit, type: .decimal)
        .withStyle(.decimal)

    private lazy var sendButton = UIButton(title: €.Button.send)
        .withStyle(.primary)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        balanceLabels,
        recipientAddressField,
        amountToSendField,
        gasPriceField,
        gasLimitField,
        .spacer,
        sendButton
    ]
}

// MARK: - SingleContentView
extension PrepareTransactionView: ViewModelled {
    typealias ViewModel = PrepareTransactionViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.isFetchingBalance                 --> rx.isRefreshing,
            viewModel.amount                            --> amountToSendField.rx.text,
            viewModel.recipient                         --> recipientAddressField.rx.text,
            viewModel.isSendButtonEnabled               --> sendButton.rx.isEnabled,
            viewModel.balance                           --> balanceLabels.rx.value,
            viewModel.recipientAddressValidation        --> recipientAddressField.rx.validation,
            viewModel.amountValidation                  --> amountToSendField.rx.validation,
            viewModel.gasLimitValidation                --> gasLimitField.rx.validation,
            viewModel.gasPriceValidation                --> gasPriceField.rx.validation
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriver(),

            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            recipientAddressDidEndEditing: recipientAddressField.rx.didEndEditing,

            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            amountDidEndEditing: amountToSendField.rx.didEndEditing,

            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasLimitDidEndEditing: gasLimitField.rx.didEndEditing,

            gasPrice: gasPriceField.rx.text.orEmpty.asDriver(),
            gasPriceDidEndEditing: gasPriceField.rx.didEndEditing
        )
    }
}

extension Reactive where Base: UITextField {
    var isEditing: Driver<Bool> {
        return Driver.merge(
            controlEvent([.editingDidBegin]).asDriver().map { true },
            controlEvent([.editingDidEnd]).asDriver().map { false }
        )
    }

    var didEndEditing: Driver<Void> {
        return isEditing.filter { !$0 }.mapToVoid()
    }
}
