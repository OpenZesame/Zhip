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

private typealias € = L10n.Scene.GotTransactionReceipt

final class GotTransactionReceiptView: ScrollingStackView {

    private lazy var successLabel = UILabel(text: €.Label.confirmed).withStyle(.title)

    private lazy var transactionFeeLabels = TitledValueView().titled(€.Labels.Fee.title)

    private lazy var openDetailsInBrowserButton = UIButton(title: €.Button.openDetailsInBrowser)
        .withStyle(.primary)

    lazy var stackViewStyle: UIStackView.Style = [
        successLabel,
        transactionFeeLabels,
        openDetailsInBrowserButton,
        .spacer
    ]
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

