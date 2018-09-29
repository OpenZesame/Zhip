//
//  WalletView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class WalletView: UIStackView, StackViewStyling {

    private lazy var addressLabels = LabelsView(
        titleStyle: "Your Public Address",
        valueStyle: UILabel.Style(numberOfLines: 0)
    )

    private lazy var publicKeyLabels = LabelsView(
        titleStyle: "Your Public Key (compressed)",
        valueStyle: UILabel.Style(numberOfLines: 0)
    )

    private lazy var balanceLabels = LabelsView(titleStyle: "Balance", valueStyle: "🤷‍♀️")
    private lazy var nonceLabels = LabelsView(titleStyle: "Current wallet nonce", valueStyle: "🤷‍♀️")

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        apply(style: stackViewStyle)
    }

    required init(coder aDecoder: NSCoder) {
        interfaceBuilderSucks
    }

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        addressLabels,
        publicKeyLabels,
        balanceLabels,
        nonceLabels,
        ], spacing: 16, margin: 0)
}

extension WalletView {

    func populate(with wallet: Wallet) {
        addressLabels.setValue(wallet.address.address)
        publicKeyLabels.setValue(wallet.keyPair.publicKey)
        balanceLabels.setValue(wallet.balance)
        nonceLabels.setValue(wallet.nonce.nonce)
    }
}


import RxSwift
import RxCocoa
extension Reactive where Base == WalletView {
    var wallet: Binder<Wallet> {
        return Binder(base) {
            $0.populate(with: $1)
        }
    }
}

