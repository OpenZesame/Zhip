//
//  UIView+Border.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-24.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIView {
    struct Border {
        let color: CGColor
        let width: CGFloat
        init(color: UIColor, width: CGFloat ) {
            self.color = color.cgColor
            self.width = width
        }
    }

    func addBorder(_ border: Border = .default) {
        layer.borderWidth = border.width
        layer.borderColor = border.color
    }
}

extension UIView.Border {

    static var `default`: UIView.Border {
        return UIView.Border(color: UIColor.gray.withAlphaComponent(0.4), width: 1)
    }
}
