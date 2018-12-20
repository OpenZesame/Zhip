//
//  ChooseWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChooseWalletView: ScrollingStackView {

    private lazy var createNewWalletButton = UIButton()

    private lazy var restoreWalletButton = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        createNewWalletButton,
        restoreWalletButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ChooseWalletView: ViewModelled {
    typealias ViewModel = ChooseWalletViewModel
    var inputFromView: InputFromView {
        return InputFromView(
            createNewWalletTrigger: createNewWalletButton.rx.tap.asDriver(),
            restoreWalletTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.ChooseWallet
private extension ChooseWalletView {
    func setupSubviews() {
        createNewWalletButton.withStyle(.primary) {
            $0.title(€.Button.newWallet)
        }

        restoreWalletButton.withStyle(.secondary) {
            $0.title(€.Button.restoreWallet)
        }
    }
}
