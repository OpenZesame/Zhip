//
//  UIView+Spacer.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIView {

    static func spacer(verticalCompressionResistancePriority: UILayoutPriority = .defaultLow, verticalContentHuggingPriority: UILayoutPriority = .defaultLow) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentCompressionResistancePriority(verticalCompressionResistancePriority, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spacer.setContentHuggingPriority(verticalContentHuggingPriority, for: .vertical)
        return spacer
    }

    static var spacer: UIView { return spacer() }
}
