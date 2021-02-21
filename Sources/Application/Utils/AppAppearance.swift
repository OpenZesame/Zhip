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

final class AppAppearance {
    static func setupDefault() {
        setupAppearance()
    }
}

private func setupAppearance() {
    setupNavigationBarAppearance()
    setupBarButtonItemAppearance()
}

func setupBarButtonItemAppearance() {
    UINavigationBar.appearance().backIndicatorImage = UIImage()
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
    UIBarButtonItem.appearance().attributeText([.font(.title), .color(.teal)], for: UIControl.State.all)
    replaceBackBarButtonImage()
}

private func replaceBackBarButtonImage() {
    let backImage = Asset.Icons.Small.chevronLeft.image
    let streched = backImage.stretchableImage(withLeftCapWidth: 15, topCapHeight: 30)
    UIBarButtonItem.appearance().setBackButtonBackgroundImage(streched, for: .normal, barMetrics: .default)
}

public extension UINavigationBar {

    static var defaultBarTintColor: UIColor {
        return .dusk
    }

    static var defaultBackgroundColor: UIColor {
        return .clear
    }

    static var defaultTintColor: UIColor {
        return .white
    }

    static var defaultTextColor: UIColor {
        return .white
    }

    static var defaultFont: UIFont {
        return .title
    }

    static var defaultIsTranslucent: Bool {
        return true
    }

    static var defaultBarStyle: UIBarStyle {
        return .blackTranslucent
    }

    static var defaultBackgroundImage: UIImage {
        return UIImage()
    }

    static var defaultShadowImage: UIImage {
        return UIImage()
    }

    static var defaultTitleTextAttributes: [NSAttributedString.Key: Any] {
        return _defaultTitleTextAttributes.attributes
    }

    static var defaultLayerShadowColor: CGColor {
        return UIColor.black.cgColor
    }

    static var defaultLayerShadowOpacity: Float {
        return 0.8
    }

    static var defaultLayerShadowOffset: CGSize {
        return CGSize(width: 5, height: 5)
    }

    static var defaultLayerShadowRadius: CGFloat {
        return 5
    }

    fileprivate static var _defaultTitleTextAttributes: [TextAttribute] {
        return [.font(UINavigationBar.defaultFont), .color(UINavigationBar.defaultTextColor)]
    }
}

extension UINavigationBar {
    var shadow: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.layer.shadowColor = UINavigationBar.defaultLayerShadowColor
                self.layer.shadowRadius = UINavigationBar.defaultLayerShadowRadius
                self.layer.shadowOffset = UINavigationBar.defaultLayerShadowOffset
                self.layer.shadowOpacity = UINavigationBar.defaultLayerShadowOpacity
            }
        }
    }
}

private func setupNavigationBarAppearance() {
    let appearance = UINavigationBar.appearance()
    appearance.shadow = true
    appearance.barStyle = UINavigationBar.defaultBarStyle
    appearance.attributeText(UINavigationBar._defaultTitleTextAttributes)
    appearance.tintColor = UINavigationBar.defaultTintColor
    appearance.barTintColor = UINavigationBar.defaultBarTintColor
    appearance.backgroundImage = UINavigationBar.defaultBackgroundImage
    appearance.shadowImage = UINavigationBar.defaultShadowImage
    appearance.backgroundColor = UINavigationBar.defaultBackgroundColor
    appearance.isTranslucent = UINavigationBar.defaultIsTranslucent
}

public extension UIControl.State {
    static let all: [UIControl.State] = [.normal, .highlighted, .disabled]
}

public protocol BarAppearance {
    var tintColor: UIColor! { get set }
    var barTintColor: UIColor? { get set }
    var backgroundImage: UIImage? { get set }
    var shadowImage: UIImage? { get set }
}

public protocol BarTextApperance {
    var titleTextAttributes: [NSAttributedString.Key: Any]? { get set }
    mutating func attributeText(_ values: [TextAttribute])
}

public extension BarTextApperance {
    mutating func attributeText(_ values: [TextAttribute]) {
        titleTextAttributes = Dictionary(uniqueKeysWithValues: values.map { ($0.key, $0.value) })
    }
}

extension UITabBar: BarAppearance {}
extension UINavigationBar: BarTextApperance {}

extension UINavigationBar: BarAppearance {}
public extension UINavigationBar {
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .default)
        }

        set {
            setBackgroundImage(newValue, for: .default)
        }
    }
}

public extension UIAppearance where Self: BarTextApperance {
    func attributeText(_ values: [TextAttribute]) {
        var selfBarTextApperance = self as BarTextApperance
        selfBarTextApperance.titleTextAttributes = values.attributes
    }
}

public extension Array where Element == TextAttribute {
    var attributes: [NSAttributedString.Key: Any] {
        return Dictionary(uniqueKeysWithValues: map { ($0.key, $0.value) })
    }
}

public enum TextAttribute {
    case font(UIFont)
    case color(UIColor)

    var key: NSAttributedString.Key {
        switch self {
        case .font: return .font
        case .color: return .foregroundColor
        }
    }

    var value: Any {
        switch self {
        case .font(let font):
            return font
        case .color(let color):
            return color
        }
    }
}

public extension UIAppearance where Self: UIBarItem {
    func attributeText(_ values: [TextAttribute], for states: [UIControl.State]) {
        for state in states {
            attributeText(values, for: state)
        }
    }

    func attributeText(_ values: [TextAttribute], for state: UIControl.State) {
        setTitleTextAttributes(values.attributes, for: state)
    }
}
