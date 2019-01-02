//
//  UILayoutPriority+Extension.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UILayoutPriority: ExpressibleByFloatLiteral {
    public init(floatLiteral rawValue: Float) {
        self.init(rawValue: rawValue)
    }
}

extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public init(integerLiteral intValue: Int) {
        self.init(rawValue: Float(intValue))
    }
}

public extension UILayoutPriority {
    static var medium: UILayoutPriority {
        let delta = UILayoutPriority.defaultHigh.rawValue - UILayoutPriority.defaultLow.rawValue
        let valueBetweenLowAndHeigh = UILayoutPriority.defaultLow.rawValue + delta / 2
        return UILayoutPriority(rawValue: valueBetweenLowAndHeigh)
    }
}
