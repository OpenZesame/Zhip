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

final class PollTransactionStatusView: ScrollingStackView {

    private lazy var waitingOnReceiptLabel  = UILabel()
    private lazy var loadingView            = SpinnerView()
    private lazy var skipWaitingButton      = UIButton()

    lazy var stackViewStyle = UIStackView.Style([
        waitingOnReceiptLabel,
        loadingView,
        skipWaitingButton
        ], distribution: .equalSpacing)

    override func setup() {
        setupSubviews()
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

private typealias € = L10n.Scene.PollTransactionStatus
private extension PollTransactionStatusView {
    func setupSubviews() {
        waitingOnReceiptLabel.withStyle(.body) {
            $0.text(€.Label.waitingOnReceipt)
        }

        skipWaitingButton.withStyle(.primary) {
            $0.title(€.Button.skip)
        }

        loadingView.startSpinning()
        loadingView.height(200, priority: .medium)
    }
}
