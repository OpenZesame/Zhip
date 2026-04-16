//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

enum AppAppearance {
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
    let backImage = UIImage(resource: .chevronLeft)
    let stretched = backImage.stretchableImage(withLeftCapWidth: 15, topCapHeight: 30)
    UIBarButtonItem.appearance().setBackButtonBackgroundImage(stretched, for: .normal, barMetrics: .default)
}

public extension UINavigationBar {
    static var defaultBarTintColor: UIColor {
        .dusk
    }

    static var defaultBackgroundColor: UIColor {
        .clear
    }

    static var defaultTintColor: UIColor {
        .white
    }

    static var defaultTextColor: UIColor {
        .white
    }

    static var defaultFont: UIFont {
        .title
    }

    static var defaultIsTranslucent: Bool {
        true
    }

    static var defaultBarStyle: UIBarStyle {
        .black
    }

    static var defaultBackgroundImage: UIImage {
        UIImage()
    }

    static var defaultShadowImage: UIImage {
        UIImage()
    }

    static var defaultTitleTextAttributes: [NSAttributedString.Key: Any] {
        _defaultTitleTextAttributes.attributes
    }

    static var defaultLayerShadowColor: CGColor {
        UIColor.black.cgColor
    }

    static var defaultLayerShadowOpacity: Float {
        0.8
    }

    static var defaultLayerShadowOffset: CGSize {
        CGSize(width: 5, height: 5)
    }

    static var defaultLayerShadowRadius: CGFloat {
        5
    }

    fileprivate static var _defaultTitleTextAttributes: [TextAttribute] {
        [.font(UINavigationBar.defaultFont), .color(UINavigationBar.defaultTextColor)]
    }
}

extension UINavigationBar {
    var shadow: Bool {
        get {
            false
        }
        set {
            if newValue {
                layer.shadowColor = UINavigationBar.defaultLayerShadowColor
                layer.shadowRadius = UINavigationBar.defaultLayerShadowRadius
                layer.shadowOffset = UINavigationBar.defaultLayerShadowOffset
                layer.shadowOpacity = UINavigationBar.defaultLayerShadowOpacity
            }
        }
    }
}

private func setupNavigationBarAppearance() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.backgroundColor = UINavigationBar.defaultBarTintColor
    navBarAppearance.titleTextAttributes = UINavigationBar.defaultTitleTextAttributes
    navBarAppearance.shadowColor = .clear

    let appearance = UINavigationBar.appearance()
    appearance.shadow = true
    appearance.tintColor = UINavigationBar.defaultTintColor
    appearance.isTranslucent = UINavigationBar.defaultIsTranslucent
    appearance.standardAppearance = navBarAppearance
    appearance.scrollEdgeAppearance = navBarAppearance
    appearance.compactAppearance = navBarAppearance
    appearance.compactScrollEdgeAppearance = navBarAppearance
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

public protocol BarTextAppearance {
    var titleTextAttributes: [NSAttributedString.Key: Any]? { get set }
    mutating func attributeText(_ values: [TextAttribute])
}

public extension BarTextAppearance {
    mutating func attributeText(_ values: [TextAttribute]) {
        titleTextAttributes = Dictionary(uniqueKeysWithValues: values.map { ($0.key, $0.value) })
    }
}

extension UITabBar: BarAppearance {}
extension UINavigationBar: BarTextAppearance {}

extension UINavigationBar: BarAppearance {}
public extension UINavigationBar {
    var backgroundImage: UIImage? {
        get {
            backgroundImage(for: .default)
        }

        set {
            setBackgroundImage(newValue, for: .default)
        }
    }
}

public extension UIAppearance where Self: BarTextAppearance {
    func attributeText(_ values: [TextAttribute]) {
        var selfBarTextAppearance = self as BarTextAppearance
        selfBarTextAppearance.titleTextAttributes = values.attributes
    }
}

public extension [TextAttribute] {
    var attributes: [NSAttributedString.Key: Any] {
        Dictionary(uniqueKeysWithValues: map { ($0.key, $0.value) })
    }
}

public enum TextAttribute {
    case font(UIFont)
    case color(UIColor)

    var key: NSAttributedString.Key {
        switch self {
        case .font: .font
        case .color: .foregroundColor
        }
    }

    var value: Any {
        switch self {
        case let .font(font):
            font
        case let .color(color):
            color
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
