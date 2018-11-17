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

final class BalanceView: LabelsView {
    override init(
        titleStyle: UILabel.Style? = nil,
        valueStyle: UILabel.Style? = nil,
        stackViewStyle: UIStackView.Style? = nil
        ) {

        super.init(
            titleStyle: titleStyle.merged(other: UILabel.Style(€.Label.balance), mode: .overrideOther),
            valueStyle: valueStyle.merged(other: UILabel.Style(numberOfLines: 0), mode: .overrideOther),
            stackViewStyle: stackViewStyle.merged(other: UIStackView.Style(spacing: 0), mode: .overrideOther)
        )
    }

    required init(coder aDecoder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension Reactive where Base == BalanceView {
    var balance: Binder<String?> {
        return value
    }
}
