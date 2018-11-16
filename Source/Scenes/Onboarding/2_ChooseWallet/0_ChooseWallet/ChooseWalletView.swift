//
//  ChooseWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.ChooseWallet

final class ChooseWalletView: ScrollingStackView {

    private lazy var createNewWalletButton = UIButton.Style(€.Button.newWallet).make()
    private lazy var restoreWalletButton = UIButton.Style(€.Button.restoreWallet, textColor: .white, colorNormal: .blue).make()

    lazy var stackViewStyle: UIStackView.Style = [
        createNewWalletButton,
        restoreWalletButton,
        .spacer
    ]
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
