//
//  WalletBalanceView.swift
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
        addressLabels
//        publicKeyLabels
        ], spacing: 16, margin: 0)
}

extension WalletView {

    func populate(with wallet: Wallet) {
        addressLabels.setValue(wallet.address.checksummedHex)
//        publicKeyLabels.setValue(wallet.keystore.)
    }

    func setAddress(_ address: String) {
        addressLabels.setValue(address)
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

