//
//  BalanceView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

import UIKit
import Zesame
import RxSwift
import RxCocoa

private typealias € = L10n.View.Balance

final class BalanceView: UIStackView, StackViewStyling {
    private lazy var balanceLabels = LabelsView(title: €.Label.balance, valueStyle: "🤷‍♀️")
    private lazy var nonceLabels = LabelsView(title: €.Label.nonce, valueStyle: "🤷‍♀️")

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
        nonceLabels
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

extension Reactive where Base == BalanceView {
    var balance: Binder<String> {
        return Binder<String>(base) {
            $0.setBalance($1)
        }
    }

    var nonce: Binder<String> {
        return Binder<String>(base) {
            $0.setNonce($1)
        }
    }
}
