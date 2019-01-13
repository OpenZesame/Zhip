//
//  ReceiveView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - ReceiveView
final class ReceiveView: ScrollableStackViewOwner {

    private lazy var qrImageView            = UIImageView()
    private lazy var addressTitleLabel      = UILabel()
    private lazy var addressValueTextView   = UITextView()
    private lazy var copyMyAddressButton    = UIButton()
    private lazy var addressAndCopyButton   = UIStackView(arrangedSubviews: [addressValueTextView, copyMyAddressButton])
    private lazy var addressViews           = UIStackView(arrangedSubviews: [addressTitleLabel, addressAndCopyButton])
    private lazy var requestingAmountField  = FloatingLabelTextField()
    private lazy var requestPaymentButton   = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        qrImageView,
        addressViews,
        requestingAmountField,
        .spacer,
        requestPaymentButton
        ])

    override func setup() {
        setupSubviews()
    }
}

// MARK: - SingleContentView
extension ReceiveView: ViewModelled {
    typealias ViewModel = ReceiveViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.receivingAddress              --> addressValueTextView.rx.text,
            viewModel.amountValidation              --> requestingAmountField.rx.validation,
            viewModel.amountBecomeFirstResponder   --> requestingAmountField.rx.becomeFirstResponder,
            viewModel.qrImage                       --> qrImageView.rx.image
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            qrCodeImageHeight: 200,
            amountToReceive: requestingAmountField.rx.text.orEmpty.asDriver().skip(1),
            didEndEditingAmount: requestingAmountField.rx.didEndEditing,
            copyMyAddressTrigger: copyMyAddressButton.rx.tap.asDriver(),
            shareTrigger: requestPaymentButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.Receive
private extension ReceiveView {

    // swiftlint:disable:next function_body_length
    func setupSubviews() {
        qrImageView.withStyle(.default)

        addressTitleLabel.withStyle(.title) {
            $0.text(€.Label.myPublicAddress)
        }

        addressValueTextView.withStyle(.init(
            font: UIFont.Label.body,
            isEditable: false,
            isScrollEnabled: false,
            // UILabel and UITextView horizontal alignment differs, change inset: stackoverflow.com/a/45113744/1311272
            contentInset: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
            )
        )

        copyMyAddressButton.withStyle(.title(€.Button.copyMyAddress))
        copyMyAddressButton.setHugging(.required, for: .horizontal)

        addressAndCopyButton.withStyle(.horizontal)
        addressViews.withStyle(.default) {
            $0.layoutMargins(.zero)
        }

        requestingAmountField.withStyle(.number) {
            $0.placeholder(€.Field.requestAmount)
        }

        requestPaymentButton.withStyle(.primary) {
            $0.title(€.Button.requestPayment)
        }
    }
}
