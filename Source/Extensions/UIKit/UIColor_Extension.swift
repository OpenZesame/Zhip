//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
