//
//  UIButton+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
            height: nil
        )
    }
}
