//
//  UITextField+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import TinyConstraints

extension UITextField {
    struct Style {
        var placeholder: String?
        let textColor: UIColor?
        let font: UIFont?
        let isSecureTextEntry: Bool?
        let keyboardType: UIKeyboardType?
        let backgroundColor: UIColor?

        init(
            placeholder: String? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            isSecureTextEntry: Bool? = nil,
            keyboardType: UIKeyboardType? = nil
            ) {
            self.placeholder = placeholder
            self.font = font
            self.textColor = textColor
            self.isSecureTextEntry = isSecureTextEntry
            self.keyboardType = keyboardType
            self.backgroundColor = backgroundColor
        }
    }
}

// MARK: - Apply Syyle
extension UITextField {
    func apply(style: Style) {
        textColor = style.textColor ?? .defaultText
        placeholder = style.placeholder
        font = style.font ?? UIFont.Field.textAndPlaceholder
        isSecureTextEntry = style.isSecureTextEntry ?? false
        if let keyboardType = style.keyboardType {
            self.keyboardType = keyboardType
        }
        backgroundColor = style.backgroundColor ?? .clear
    }
}

// MARK: - Style + Customizing
extension UITextField.Style {
    @discardableResult
    func placeholder(_ placeholder: String?) -> UITextField.Style {
        var style = self
        style.placeholder = placeholder
        return style
    }
}

// MARK: - Style Presets
extension UITextField.Style {
    static var `default`: UITextField.Style {
        return UITextField.Style()
    }

    static var password: UITextField.Style {
        return UITextField.Style(isSecureTextEntry: true)
    }

    static var number: UITextField.Style {
        return UITextField.Style(keyboardType: .numberPad)
    }
}
