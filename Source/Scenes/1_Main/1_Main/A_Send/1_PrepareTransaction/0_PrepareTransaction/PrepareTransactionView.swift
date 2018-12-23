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

final class PrepareTransactionView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceLabels                  = TitledValueView()
    private lazy var recipientAddressField          = TextField()
    private lazy var scanQRButton                   = UIButton()
    private lazy var amountToSendField              = TextField()
    private lazy var gasMeasuredInSmallUnitsLabel   = UILabel()
    private lazy var gasPriceField                  = TextField()
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
        prefillValuesForDebugBuilds()
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
            viewModel.balance                           --> balanceLabels.rx.value,
            viewModel.recipientAddressValidation        --> recipientAddressField.rx.validation,
            viewModel.amountValidation                  --> amountToSendField.rx.validation,
            viewModel.gasPricePlaceholder               --> gasPriceField.rx.placeholder,
            viewModel.gasPriceValidation                --> gasPriceField.rx.validation
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            scanQRTrigger: scanQRButton.rx.tap.asDriver(),
            sendTrigger: sendButton.rx.tap.asDriver(),

            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            recipientAddressDidEndEditing: recipientAddressField.rx.didEndEditing,

            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            amountDidEndEditing: amountToSendField.rx.didEndEditing,

            gasPrice: gasPriceField.rx.text.orEmpty.asDriver(),
            gasPriceDidEndEditing: gasPriceField.rx.didEndEditing
        )
    }
}

// MARK: - Private
private typealias € = L10n.Scene.PrepareTransaction
private extension PrepareTransactionView {
    func setupSubiews() {
        recipientAddressField.rightView = scanQRButton
        recipientAddressField.rightViewMode = .always

        balanceLabels.titled(€.Labels.Balance.title)

        recipientAddressField.withStyle(.address) {
            $0.placeholder(€.Field.recipient)
        }

        scanQRButton.withStyle(.image(Asset.Icons.Small.camera.image))

        amountToSendField.withStyle(.number) {
            $0.placeholder(€.Field.amount)
        }

        gasMeasuredInSmallUnitsLabel.withStyle(.body) {
            $0.text(€.Label.gasInSmallUnits)
        }

        gasPriceField.withStyle(.number)

        sendButton.withStyle(.primary) {
            $0.title(€.Button.send)
                .disabled()
        }
    }
}

// MARK: - Debug builds only
private extension PrepareTransactionView {
    func prefillValuesForDebugBuilds() {
        guard isDebug else { return }
        recipientAddressField.text = "74C544A11795905C2C9808F9E78D8156159D32E4"
        amountToSendField.text = Int.random(in: 1...200).description
        gasPriceField.text = Int.random(in: 100...200).description

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [unowned self] in
            [
                self.recipientAddressField,
                self.amountToSendField,
                self.gasPriceField
                ].forEach {
                    $0.sendActions(for: .editingDidEnd)
            }
        }
    }
}
