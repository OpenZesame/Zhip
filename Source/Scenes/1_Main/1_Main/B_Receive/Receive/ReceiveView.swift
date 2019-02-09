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
