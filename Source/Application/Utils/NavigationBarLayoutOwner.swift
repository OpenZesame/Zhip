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
