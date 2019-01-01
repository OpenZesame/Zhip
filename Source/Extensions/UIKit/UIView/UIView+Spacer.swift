//
//  UIView+Spacer.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import TinyConstraints

extension UIView {

    static func spacer(
        verticalCompressionResistancePriority: UILayoutPriority = .medium,
        verticalContentHuggingPriority: UILayoutPriority = .medium
        ) -> UIView {

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        spacer.setContentCompressionResistancePriority(.medium, for: .horizontal)
        spacer.setContentCompressionResistancePriority(verticalCompressionResistancePriority, for: .vertical)

        spacer.setContentHuggingPriority(.medium, for: .horizontal)
        spacer.setContentHuggingPriority(verticalContentHuggingPriority, for: .vertical)

        return spacer
    }

    static var spacer: UIView { return spacer() }

    static func spacer(height: CGFloat) -> UIView {
        let spacer: UIView = .spacer
        spacer.height(height)
        return spacer
    }
}
