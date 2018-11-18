//
//  UIFont_Extension.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

struct Font {
    let size: FontSize
    let weight: FontWeight
    init(_ size: FontSize, _ weight: FontWeight) {
        self.size = size
        self.weight = weight
    }
}

// Font size name inspired by LaTeX
// readmore: https://texblog.org/2012/08/29/changing-the-font-size-in-latex/
extension UIFont {
    static let tiny = Font(.𝟙𝟛, .medium).make()
    static let Tiny = Font(.𝟙𝟞, .regular).make()
    static let small = Font(.𝟙𝟠, .regular).make()
    static let Small = Font(.𝟙𝟠, .medium).make()
    static let large = Font(.𝟚𝟚, .medium).make()
    static let Large = Font(.𝟛𝟜, .medium).make()
    static let huge = Font(.𝟞𝟚, .medium).make()
    static let Huge = Font(.𝟟𝟚, .medium).make()
}

extension Font {
    enum FontSize: CGFloat {
        // 𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡
        case 𝟙𝟛 = 13
        case 𝟙𝟞 = 16
        case 𝟙𝟠 = 18
        case 𝟚𝟚 = 22
        case 𝟛𝟜 = 34
        case 𝟞𝟚 = 62
        case 𝟟𝟚 = 72
    }
    enum FontWeight {
        case regular, medium
    }
}

extension Font {
    func make() -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue, weight: weight.weight)
    }
}

extension Font.FontWeight {
    var weight: UIFont.Weight {
        switch self {
        case .medium: return .medium
        case .regular: return .regular
        }
    }
}

extension UIFont {
    enum Button {
        static let primary: UIFont = .large
        static let seconday: UIFont = .small
    }

    enum Label {
        static let title: UIFont = .large
        static let value: UIFont = .small
    }

    enum Field {
        static let placeholder: UIFont = .tiny
        static let text: UIFont = .Small
    }
}
