//
//  MainView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.Main

private extension MainView {
    func setupSubviews() {

        balanceLabels.withStyles(
            forTitle: .impression,
            forValue: .header
        ) {
            $0.text(€.Label.Balance.title)
        }

        sendButton.withStyle(.primary) {
            $0.title(€.Button.send)
        }

        receiveButton.withStyle(.secondary) {
            $0.title(€.Button.receive)
        }
    }
}

final class MainView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceLabels  = TitledValueView()
    private lazy var sendButton     = UIButton()
    private lazy var receiveButton  = UIButton()

    lazy var stackViewStyle = UIStackView.Style([
        balanceLabels,
        .spacer(verticalContentHuggingPriority: .defaultHigh),
        sendButton,
        receiveButton
        ], spacing: 8)

    override func setup() {
        setupSubviews()
    }
}

extension MainView: ViewModelled {
    typealias ViewModel = MainViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriverOnErrorReturnEmpty(),
            receiveTrigger: receiveButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: MainViewModel.Output) -> [Disposable] {
        return [
            viewModel.isFetchingBalance     --> rx.isRefreshing,
            viewModel.balance               --> balanceLabels.rx.value
        ]
    }
}
