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

final class WalletView: UIStackView, StackViewStyling {

    fileprivate lazy var addressLabels = LabelsView(
        titleStyle: "Your Public Address",
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
    ], spacing: 16, margin: 0)
}

extension Reactive where Base == WalletView {
    var address: Binder<String> {
        return Binder(base) {
            $0.addressLabels.setValue($1)
        }
    }
}

