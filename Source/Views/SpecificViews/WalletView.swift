//
//  WalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

import RxSwift
import RxCocoa

private typealias € = L10n.View.Wallet

final class WalletView: LabelsView {
    override init(
        titleStyle: UILabel.Style? = nil,
        valueStyle: UILabel.Style? = nil,
        stackViewStyle: UIStackView.Style? = nil
        ) {

        super.init(
            titleStyle: titleStyle.merged(other: UILabel.Style(€.Label.yourAddress), mode: .overrideOther),
            valueStyle: valueStyle.merged(other: UILabel.Style(numberOfLines: 0), mode: .overrideOther),
            stackViewStyle: stackViewStyle.merged(other: UIStackView.Style(spacing: 0), mode: .overrideOther)
        )

    }

    required init(coder aDecoder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension Reactive where Base == WalletView {
    var address: Binder<String?> {
        return value
    }
}

