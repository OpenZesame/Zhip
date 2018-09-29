//
//  ChooseWalletView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChooseWalletView: ScrollingStackView {

    private lazy var createNewWalletButton: UIButton = "New Wallet"
    private lazy var restoreWalletButton: UIButton = "Restore Wallet"

    lazy var stackViewStyle: UIStackView.Style = [
        createNewWalletButton,
        restoreWalletButton,
        .spacer
    ]
}

extension ChooseWalletView: ViewModelled {
    typealias ViewModel = ChooseWalletViewModel
    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            createNewTrigger: createNewWalletButton.rx.tap.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }
}
