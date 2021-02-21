// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
        case mellowYellow = 0xFFD14C
        case deepBlue = 0x1F292F
        case bloodRed = 0xFF4C4F
        case asphaltGrey = 0x40484D
        case silverGrey = 0x6F7579

        // Dark color used for navigation bar
        case dusk = 0x192226
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
    static let mellowYellow = UIColor(hex: .mellowYellow)
    static let bloodRed = UIColor(hex: .bloodRed)
    static let asphaltGrey = UIColor(hex: .asphaltGrey)
    static let silverGrey = UIColor(hex: .silverGrey)
    static let dusk = UIColor(hex: .dusk)
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
