//
//  GotTransactionReceiptView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GotTransactionReceiptView: ScrollingStackView {

    private lazy var successLabel                   = UILabel()
    private lazy var transactionFeeLabels           = TitledValueView()
    private lazy var openDetailsInBrowserButton     = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        successLabel,
        transactionFeeLabels,
        openDetailsInBrowserButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension GotTransactionReceiptView: ViewModelled {
    typealias ViewModel = GotTransactionReceiptViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.transactionFee --> transactionFeeLabels.rx.value
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            openDetailsInBrowserTrigger: openDetailsInBrowserButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.GotTransactionReceipt
private extension GotTransactionReceiptView {
    func setupSubviews() {
        successLabel.withStyle(.header) {
            $0.text(€.Label.confirmed)
        }

        transactionFeeLabels.titled(€.Labels.Fee.title)

        openDetailsInBrowserButton.withStyle(.primary) {
            $0.title(€.Button.openDetailsInBrowser)
        }
    }
}
