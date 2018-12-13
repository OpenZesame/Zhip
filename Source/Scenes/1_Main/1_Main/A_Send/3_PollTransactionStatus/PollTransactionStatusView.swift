//
//  PollTransactionStatusView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.PollTransactionStatus

final class PollTransactionStatusView: ScrollingStackView {

    private lazy var waitingOnReceiptLabel = UILabel(text: €.Label.waitingOnReceipt).withStyle(.body)

    private lazy var loadingView = SpinnerView()

    private lazy var skipWaitingButton = UIButton(title: €.Button.skip)
        .withStyle(.primary)

    lazy var stackViewStyle = UIStackView.Style([
        waitingOnReceiptLabel,
        loadingView,
        skipWaitingButton
        ], distribution: .equalSpacing)

    override func setup() {
        loadingView.startSpinning()
        loadingView.height(200, priority: .medium)
    }
}

extension PollTransactionStatusView: ViewModelled {
    typealias ViewModel = PollTransactionStatusViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            skipWaitingTrigger: skipWaitingButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

