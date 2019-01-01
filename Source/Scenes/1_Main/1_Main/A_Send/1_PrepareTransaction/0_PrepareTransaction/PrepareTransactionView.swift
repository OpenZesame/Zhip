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

private typealias € = L10n.Scene.PrepareTransaction
final class PrepareTransactionView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceTitleLabel              = UILabel()
    private lazy var balanceValueLabel              = UILabel()
    private lazy var balanceLabels                  = UIStackView(arrangedSubviews: [balanceTitleLabel, balanceValueLabel])
    private lazy var recipientAddressField          = FloatingLabelTextField()
    private lazy var scanQRButton = recipientAddressField.addBottomAlignedButton(asset: Asset.Icons.Small.camera)
    private lazy var amountToSendField              = FloatingLabelTextField()
    private lazy var maxAmounButton = amountToSendField.addBottomAlignedButton(titled: €.Button.maxAmount)
    private lazy var gasMeasuredInSmallUnitsLabel   = UILabel()
    private lazy var gasPriceField                  = FloatingLabelTextField()
    private lazy var sendButton                     = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        balanceLabels,
        recipientAddressField,
        amountToSendField,
        gasPriceField,
        .spacer,
        sendButton
    ]

    override func setup() {
        setupSubiews()
//        prefillValuesForDebugBuilds()
    }
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
            viewModel.balance                           --> balanceValueLabel.rx.text,
            viewModel.recipientAddressValidation        --> recipientAddressField.rx.validation,
            viewModel.amountValidation                  --> amountToSendField.rx.validation,
            viewModel.gasPriceMeasuredInLi              --> gasPriceField.rx.text,
            viewModel.gasPricePlaceholder               --> gasPriceField.rx.placeholder,
            viewModel.gasPriceValidation                --> gasPriceField.rx.validation
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            scanQRTrigger: scanQRButton.rx.tap.asDriver(),
            maxAmountTrigger: maxAmounButton.rx.tap.asDriver(),
            sendTrigger: sendButton.rx.tap.asDriver(),

            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver().skip(1),
            didEndEditingRecipientAddress: recipientAddressField.rx.didEndEditing,

            amountToSend: amountToSendField.rx.text.orEmpty.asDriver().skip(1),
            didEndEditingAmount: amountToSendField.rx.didEndEditing,

            gasPrice: gasPriceField.rx.text.orEmpty.asDriver().skip(1),
            didEndEditingGasPrice: gasPriceField.rx.didEndEditing
        )
    }
}

// MARK: - Private
private extension PrepareTransactionView {

    // swiftlint:disable function_body_length
    func setupSubiews() {

        balanceTitleLabel.withStyle(.title) {
            $0.text(€.Labels.Balance.title)
        }

        balanceValueLabel.withStyle(.body)

        balanceLabels.withStyle(.horizontal)

        recipientAddressField.withStyle(.address) {
            $0.placeholder(€.Field.recipient)
        }

        recipientAddressField.rightView = scanQRButton
        recipientAddressField.rightViewMode = .always

        amountToSendField.withStyle(.number) {
            $0.placeholder(€.Field.amount)
        }

        gasMeasuredInSmallUnitsLabel.withStyle(.body) {
            $0.text(€.Label.gasInSmallUnits("\(Unit.li.name) (\(Unit.li.powerOf))"))
        }

        gasPriceField.withStyle(.number)

        sendButton.withStyle(.primary) {
            $0.title(€.Button.send)
                .disabled()
        }
    }
}

//// MARK: - Debug builds only
//private extension PrepareTransactionView {
//    func prefillValuesForDebugBuilds() {
//        guard isDebug else { return }
//        recipientAddressField.text = "74C544A11795905C2C9808F9E78D8156159D32E4"
//        amountToSendField.text = Int.random(in: 1...200).description
//        gasPriceField.text = Int.random(in: 100...200).description
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [unowned self] in
//            [
//                self.recipientAddressField,
//                self.amountToSendField,
//                self.gasPriceField
//                ].forEach {
//                    $0.sendActions(for: .editingDidEnd)
//            }
//        }
//    }
//}
