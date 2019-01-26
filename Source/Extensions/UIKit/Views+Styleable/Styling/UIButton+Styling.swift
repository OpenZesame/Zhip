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

extension UIButton {
    func setOptional<Attribute>(_ keyPath: ReferenceWritableKeyPath<UIButton, Attribute?>, ifNotNil attribute: Attribute?) {
        guard let attribute = attribute else { return }
        self[keyPath: keyPath] = attribute
    }

    func set<Attribute>(_ keyPath: ReferenceWritableKeyPath<UIButton, Attribute>, ifNotNil attribute: Attribute?) {
        guard let attribute = attribute else { return }
        self[keyPath: keyPath] = attribute
    }
}

extension UIView {
    enum Rounding {
        case `static`(CGFloat)

        func apply(to view: UIView, maskToBounds: Bool = true) {
            switch self {
            case .static(let radius):
                view.layer.cornerRadius = radius
            }
            if maskToBounds {
                view.layer.masksToBounds = true
            }
        }
    }
}

extension UIButton {
    public struct Style {
        fileprivate var titleNormal: String?
        fileprivate var imageNormal: UIImage?
        var tintColor: UIColor?
        var height: CGFloat?
        let textColorNormal: UIColor?
        let textColorDisabled: UIColor?
        let colorNormal: UIColor?
        let colorDisabled: UIColor?
        let colorSelected: UIColor?
        let font: UIFont?
        var isEnabled: Bool?
        let borderNormal: Border?
        let cornerRounding: UIView.Rounding?

        init(
            titleNormal: String? = nil,
            imageNormal: UIImage? = nil,
            tintColor: UIColor? = UIColor.teal,
            height: CGFloat? = defaultHeight,
            font: UIFont? = nil,
            textColorNormal: UIColor? = nil,
            textColorDisabled: UIColor? = nil,
            colorNormal: UIColor? = nil,
            colorDisabled: UIColor? = nil,
            colorSelected: UIColor? = nil,
            borderNormal: Border? = nil,
            isEnabled: Bool? = nil,
            cornerRounding: UIView.Rounding? = nil
            ) {
            self.titleNormal = titleNormal
            self.imageNormal = imageNormal
            self.tintColor = tintColor
            self.height = height
            self.textColorNormal = textColorNormal
            self.textColorDisabled = textColorDisabled
            self.colorNormal = colorNormal
            self.colorDisabled = colorDisabled
            self.colorSelected = colorSelected
            self.font = font
            self.isEnabled = isEnabled
            self.borderNormal = borderNormal
            self.cornerRounding = cornerRounding
        }
    }
}

private let defaultHeight: CGFloat = 64

extension UIButton {

    // swiftlint:disable:next function_body_length
    func apply(style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        if let height = style.height {
            self.height(height)
        }
        if let titleNormal = style.titleNormal {
            setTitle(titleNormal, for: .normal)
        }
        if let imageNormal = style.imageNormal {
            setImage(imageNormal, for: .normal)
        }
        set(\.tintColor, ifNotNil: style.tintColor)
        setTitleColor(style.textColorNormal ?? .defaultText, for: .normal)
        setTitleColor(style.textColorDisabled ?? .silverGrey, for: .disabled)
        titleLabel?.font = style.font ?? UIFont.button
        let colorNormal = style.colorNormal ?? .teal
        let colorDisabled = style.colorDisabled ?? .asphaltGrey
        let colorSelected = style.colorSelected ?? colorNormal
        setBackgroundColor(colorNormal, for: .normal)
        setBackgroundColor(colorDisabled, for: .disabled)
        setBackgroundColor(colorSelected, for: .selected)
        isEnabled = style.isEnabled ?? true
        if let borderNormal = style.borderNormal {
            addBorder(borderNormal)
        }

        if let cornerRounding = style.cornerRounding {
            cornerRounding.apply(to: self)
        }
    }

    @discardableResult
    func withStyle<B>(_ style: UIButton.Style, customize: ((UIButton.Style) -> UIButton.Style)? = nil) -> B where B: UIButton {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        guard let button = self as? B else { incorrectImplementation("Bad cast") }
        return button
    }
}

// MARK: - Style + Customizing
extension UIButton.Style {
    @discardableResult
    func disabled() -> UIButton.Style {
        var style = self
        style.isEnabled = false
        return style
    }

    @discardableResult
    func title(_ titleNormal: String) -> UIButton.Style {
        var style = self
        style.titleNormal = titleNormal
        return style
    }

    @discardableResult
    func height(_ height: CGFloat?) -> UIButton.Style {
        var style = self
        style.height = height
        return style
    }
}

// MARK: - Style Presets
extension UIButton.Style {

    static var primary: UIButton.Style {
        return UIButton.Style(
            textColorNormal: .white,
            textColorDisabled: .silverGrey,
            colorNormal: .teal,
            colorDisabled: .asphaltGrey,
            cornerRounding: .static(8)
        )
    }

    static var secondary: UIButton.Style {
        return UIButton.Style(
            textColorNormal: .teal,
            colorNormal: .clear
        )
    }

    static var hollow: UIButton.Style {
        return UIButton.Style(
            height: 44,
            textColorNormal: .teal,
            colorNormal: .clear,
            borderNormal: UIView.Border(color: .teal, width: 1),
            cornerRounding: .static(8)
        )
    }

    static func image(_ image: UIImage) -> UIButton.Style {
        return UIButton.Style(
            imageNormal: image,
            height: nil,
            font: .title,
            textColorNormal: .teal,
            colorNormal: .clear,
            cornerRounding: nil
        )
    }

    static func title(_ title: String) -> UIButton.Style {
        return UIButton.Style(
            titleNormal: title,
            height: nil,
            font: .title,
            textColorNormal: .teal,
            colorNormal: .clear,
            cornerRounding: nil
        )
    }
}
