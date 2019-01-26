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

public protocol NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout { get }
}

public extension UINavigationBar {
    @discardableResult
    func applyLayout(_ layout: NavigationBarLayout) -> NavigationBarLayout {
        barStyle = layout.barStyle
        isTranslucent = layout.isTranslucent

        barTintColor = layout.barTintColor
        tintColor = layout.tintColor
        backgroundColor = layout.backgroundColor

        backgroundImage = layout.backgroundImage
        shadowImage = layout.shadowImage
        titleTextAttributes = layout.titleTextAttributes

        return layout
    }
}

public struct NavigationBarLayout: Equatable {
    public static func == (lhs: NavigationBarLayout, rhs: NavigationBarLayout) -> Bool {
        return lhs.visibility == rhs.visibility &&
            lhs.isTranslucent == rhs.isTranslucent &&
            lhs.tintColor == rhs.tintColor &&
            lhs.barTintColor == rhs.barTintColor &&
            lhs.backgroundColor == rhs.backgroundColor &&
            lhs.backgroundImage == rhs.backgroundImage &&
            lhs.shadowImage == rhs.shadowImage &&
            lhs.titleFont == rhs.titleFont &&
            lhs.titleColor == rhs.titleColor
    }

    public let barStyle: UIBarStyle
    public let visibility: Visibility
    public let isTranslucent: Bool

    public let tintColor: UIColor
    public let barTintColor: UIColor
    public let backgroundColor: UIColor

    public let backgroundImage: UIImage
    public let shadowImage: UIImage

    public let titleFont: UIFont
    public let titleColor: UIColor

    public var titleTextAttributes: [NSAttributedString.Key: Any] {
        return [.font(titleFont), .color(titleColor)].attributes
    }

    public init(
        barStyle: UIBarStyle = UINavigationBar.defaultBarStyle,
        visibility: Visibility = .visible(animated: false),
        isTranslucent: Bool? = nil,
        barTintColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        backgroundImage: UIImage? = nil,
        shadowImage: UIImage? = nil,
        titleFont: UIFont? = nil,
        titleColor: UIColor? = nil
        ) {
        self.barStyle = barStyle
        self.visibility = visibility
        self.isTranslucent = isTranslucent ?? UINavigationBar.defaultIsTranslucent

        self.barTintColor = barTintColor ?? UINavigationBar.defaultBarTintColor
        self.tintColor = tintColor ?? UINavigationBar.defaultTintColor
        self.backgroundColor = backgroundColor ?? UINavigationBar.defaultBackgroundColor

        self.backgroundImage = backgroundImage ?? UINavigationBar.defaultBackgroundImage
        self.shadowImage = shadowImage ?? UINavigationBar.defaultShadowImage

        self.titleFont = titleFont ?? UINavigationBar.defaultFont
        self.titleColor = titleColor ?? UINavigationBar.defaultTextColor
    }
    public enum Visibility: Equatable {
        case hidden(animated: Bool)
        case visible(animated: Bool)
        var isHidden: Bool {
            switch self {
            case .hidden: return true
            default: return false
            }
        }
        var animated: Bool {
            switch self {
            case .hidden(let animated): return animated
            case .visible(let animated): return animated
            }
        }
    }
}

public extension NavigationBarLayout {
    public static var `default`: NavigationBarLayout = .opaque

    public static var opaque: NavigationBarLayout {
        return NavigationBarLayout(
            isTranslucent: false
        )
    }

    public static var transluscent: NavigationBarLayout {
        return transluscent()
    }

    public static func transluscent(tintColor: UIColor? = nil, titleColor: UIColor? = nil) -> NavigationBarLayout {
        return NavigationBarLayout(
            isTranslucent: true,
            tintColor: tintColor,
            backgroundColor: .clear,
            titleColor: titleColor
        )
    }

    public static var hidden: NavigationBarLayout {
        return NavigationBarLayout(
            visibility: .hidden(animated: false)
        )
    }
}
