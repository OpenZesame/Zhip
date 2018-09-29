//
//  RestoreWalletView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class RestoreWalletView: ScrollingStackView {

    private lazy var privateKeyField: UITextField = "Private Key"
    private lazy var restoreWalletButton: UIButton = "Restore Wallet"

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        restoreWalletButton,
        .spacer
    ]
}

extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            privateKey: privateKeyField.rx.text.orEmpty.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }
}
