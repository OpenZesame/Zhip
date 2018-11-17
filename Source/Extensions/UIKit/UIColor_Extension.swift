//
//  UIColor_Extension.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public extension UIColor {
    static var defaultText: UIColor {
        return .black
    }
}

extension UIColor {
    enum Hex: Int {
        case zilliqaCyan = 0x66bebf
        case zilliqaDarkBlue = 0x071d38
    }
}

extension UIColor {
    static let zilliqaCyan = UIColor(hex: .zilliqaCyan)
    static let zilliqaDarkBlue = UIColor(hex: .zilliqaDarkBlue)
}

// MARK: - Private
private extension UIColor {
    convenience init(hex: Hex, alpha: CGFloat = 1.0) {
        let hexInt: Int = hex.rawValue
        let components = (
            R: CGFloat((hexInt >> 16) & 0xff) / 255,
            G: CGFloat((hexInt >> 08) & 0xff) / 255,
            B: CGFloat((hexInt >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}
