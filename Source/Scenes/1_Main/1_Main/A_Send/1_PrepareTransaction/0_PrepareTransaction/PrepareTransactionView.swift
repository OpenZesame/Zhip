// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

import Zesame

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.PrepareTransaction
final class PrepareTransactionView: ScrollableStackViewOwner, PullToRefreshCapable {

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
    private lazy var costOfTransactionLabel         = UILabel()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        balanceLabels,
        recipientAddressField,
        amountToSendField,
        gasPriceField,
        costOfTransactionLabel,
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
            viewModel.refreshControlLastUpdatedTitle    --> rx.pullToRefreshTitle,
            viewModel.isFetchingBalance                 --> rx.isRefreshing,
            viewModel.amount                            --> amountToSendField.rx.text,
            viewModel.recipient                         --> recipientAddressField.rx.text,
            viewModel.isSendButtonEnabled               --> sendButton.rx.isEnabled,
            viewModel.balance                           --> balanceValueLabel.rx.text,
            viewModel.recipientAddressValidation        --> recipientAddressField.rx.validation,
            viewModel.amountValidation                  --> amountToSendField.rx.validation,
            viewModel.gasPriceMeasuredInLi              --> gasPriceField.rx.text,
            viewModel.gasPricePlaceholder               --> gasPriceField.rx.placeholder,
            viewModel.gasPriceValidation                --> gasPriceField.rx.validation,
            viewModel.costOfTransaction                 --> costOfTransactionLabel.rx.text
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

        balanceValueLabel.withStyle(.body) {
            $0.textAlignment(.right)
        }

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

        costOfTransactionLabel.withStyle(.body) {
            $0.textAlignment(.center)
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
        #if DEBUG
        recipientAddressField.text = "89a810e6dB25912028f704b4947a6dCF724139Ae"
        amountToSendField.text = Int.random(in: 100...500).description
        gasPriceField.text = Int.random(in: 1000...2000).description

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [unowned self] in
            [
                self.recipientAddressField,
                self.amountToSendField,
                self.gasPriceField
                ].forEach {
                    $0.sendActions(for: .editingDidEnd)
            }
        }
        #endif
    }
}
