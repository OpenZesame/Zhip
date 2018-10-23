//
//  BalanceView.swift
//  ZilliqaSDKiOSExample
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class BalanceView: UIStackView, StackViewStyling {
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
        balanceLabels,
        nonceLabels,
        ], spacing: 16, margin: 0)
}


extension BalanceView {

    func populate(with walletBalance: WalletBalance) {
        balanceLabels.setValue(walletBalance.balance)
        nonceLabels.setValue(walletBalance.nonce.nonce)
    }

    func setBalance(_ balance: String) {
        balanceLabels.setValue(balance)
    }

    func setNonce(_ nonce: String) {
        nonceLabels.setValue(nonce)
    }
}
