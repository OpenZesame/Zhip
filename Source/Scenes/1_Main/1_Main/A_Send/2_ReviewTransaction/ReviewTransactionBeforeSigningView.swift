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
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.ReviewTransactionBeforeSigning

final class ReviewTransactionBeforeSigningView: ScrollableStackViewOwner {

    private lazy var recipientAddressesLabel                = UILabel()
    private lazy var recipientLegacyAddressView             = TitledValueView()
    private lazy var recipientBech32AddressView             = TitledValueView()
    private lazy var recipientViewsStackView                = UIStackView(arrangedSubviews: [recipientAddressesLabel, recipientLegacyAddressView, recipientBech32AddressView])
    
    private lazy var amountLabel                            = UILabel()
    private lazy var amountToSendView                       = TitledValueView()
    private lazy var transactionFeeView                     = TitledValueView()
    private lazy var totalCostOfTransactionView             = TitledValueView()
    private lazy var amountViewsStackView                   = UIStackView(arrangedSubviews: [
        amountLabel,
        amountToSendView,
        transactionFeeView,
        totalCostOfTransactionView
    ])
    
    private lazy var hasReviewedPaymentCheckBox             = CheckboxWithLabel()
    private lazy var acceptPaymentProceedToSigningButton    = UIButton()
    
    lazy var stackViewStyle: UIStackView.Style = [
        recipientViewsStackView,
        amountViewsStackView,
        hasReviewedPaymentCheckBox,
        acceptPaymentProceedToSigningButton,
        .spacer
    ]
    
    override func setup() {
        setupSubviews()
    }
}

extension ReviewTransactionBeforeSigningView: ViewModelled {
    typealias ViewModel = ReviewTransactionBeforeSigningViewModel
    
    var inputFromView: InputFromView {
        return InputFromView(
            isHasReviewedPaymentCheckboxChecked: hasReviewedPaymentCheckBox.rx.isChecked.asDriverOnErrorReturnEmpty(),
            hasReviewedNowProceedWithSigningTrigger: acceptPaymentProceedToSigningButton.rx.tap.asDriver()
        )
    }
    
    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isHasReviewedNowProceedWithSigningButtonEnabled --> acceptPaymentProceedToSigningButton.rx.isEnabled,
            viewModel.recipientBech32Address --> recipientBech32AddressView.rx.value,
            viewModel.recipientLegacyAddress --> recipientLegacyAddressView.rx.value,
            viewModel.amountToPay            --> amountToSendView.rx.value,
            viewModel.paymentFee             --> transactionFeeView.rx.value,
            viewModel.totalCost              --> totalCostOfTransactionView.rx.value
        ]
    }
}

private extension ReviewTransactionBeforeSigningView {
    
    // swiftlint:disable:next function_body_length
    func setupSubviews() {
        
        func setup(titledValueView: TitledValueView, customizeTitleStyle: @escaping ((UILabel.Style) -> (UILabel.Style))) {
            
            let titleStyle: UILabel.Style = UILabel.Style.body.font(UIFont.valueTitle)
            let valueStyle: UITextView.Style = UITextView.Style.nonSelectable
                .isScrollEnabled(false)
                .textAlignment(.natural)
                .textColor(.teal)
                .font(.value)

            let stackViewStyle = UIStackView.Style(
                spacing: -2,
                layoutMargins: .zero,
                isLayoutMarginsRelativeArrangement: false
            )
            
            titledValueView.withStyles(
                forTitle: titleStyle,
                forValue: valueStyle,
                forStackView: stackViewStyle,
                customizeTitleStyle: customizeTitleStyle)
        }
        
        let labelStyleForHeaders: UILabel.Style = .header
        let stackViewStyle: UIStackView.Style = .vertical
        
        // MARK: - Recipient views
        recipientAddressesLabel.withStyle(labelStyleForHeaders) {
            $0.text(€.Label.recipient)
        }
        
        setup(titledValueView: recipientLegacyAddressView) {
            $0.text(€.Label.Address.legacy)
        }
        
        setup(titledValueView: recipientBech32AddressView) {
            $0.text(€.Label.Address.bech32)
        }
        
        recipientViewsStackView.withStyle(stackViewStyle)
        
        // MARK: - Amount views
        amountLabel.withStyle(labelStyleForHeaders) {
            $0.text(€.Label.amount)
        }

        setup(titledValueView: amountToSendView) {
            $0.text(€.Label.amountToSend)
        }
        
        setup(titledValueView: transactionFeeView) {
            $0.text(€.Label.transactionFee)
        }
        
        setup(titledValueView: totalCostOfTransactionView) {
            $0.text(€.Label.totalCostOfTransaction)
        }
        
        amountViewsStackView.withStyle(stackViewStyle)
        
        // MARK: Checkbox and button
        hasReviewedPaymentCheckBox.withStyle(.default) {
            $0.text(€.Checkbox.hasReviewedPayment)
        }

        acceptPaymentProceedToSigningButton.withStyle(.primary) {
            $0.title(€.Button.hasReviewedProceedToSigning)
                .disabled()
        }
    }
}
