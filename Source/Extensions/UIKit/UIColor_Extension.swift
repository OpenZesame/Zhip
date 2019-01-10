//
//  UIColor_Extension.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public extension UIColor {
    static var defaultText: UIColor {
        return .white
    }
}

extension UIColor {
    enum Hex: Int {
        case teal = 0x00A88D

        case darkTeal = 0x0F675B
        case deepBlue = 0x1F292F
        case bloodRed = 0xFF4C4F
        case asphaltGrey = 0x40484D
        case silverGrey = 0x6F7579
    }
}

extension UIColor {
    var hexString: String {

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}

extension UIColor {
    static let teal = UIColor(hex: .teal)
    static let darkTeal = UIColor(hex: .darkTeal)
    static let deepBlue = UIColor(hex: .deepBlue)
    static let bloodRed = UIColor(hex: .bloodRed)
    static let asphaltGrey = UIColor(hex: .asphaltGrey)
    static let silverGrey = UIColor(hex: .silverGrey)
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
