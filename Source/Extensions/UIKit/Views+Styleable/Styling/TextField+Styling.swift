//
//  UITextField+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import TinyConstraints

extension TextField {
    struct Style {
        var typeOfInput: TypeOfInput
        var placeholder: String?
        let textColor: UIColor?
        let font: UIFont?
        let placeholderFont: UIFont?
        let isSecureTextEntry: Bool?
        let keyboardType: UIKeyboardType?
        let backgroundColor: UIColor?

        init(
            typeOfInput: TypeOfInput,
            placeholder: String? = nil,
            font: UIFont? = nil,
            placeholderFont: UIFont? = nil,
            textColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            isSecureTextEntry: Bool? = nil,
            keyboardType: UIKeyboardType? = nil
            ) {
            self.typeOfInput = typeOfInput
            self.placeholder = placeholder
            self.font = font
            self.placeholderFont = placeholderFont
            self.textColor = textColor
            self.isSecureTextEntry = isSecureTextEntry
            self.keyboardType = keyboardType
            self.backgroundColor = backgroundColor
        }
    }
}

// MARK: - Apply Syyle
extension TextField {
    func apply(style: Style) {
        typeOfInput = style.typeOfInput
        textColor = style.textColor ?? .defaultText
        placeholder = style.placeholder
        placeholderFont = style.placeholderFont ?? UIFont.Field.floatingPlaceholder
        font = style.font ?? UIFont.Field.textAndPlaceholder
        isSecureTextEntry = style.isSecureTextEntry ?? false
        if let keyboardType = style.keyboardType {
            self.keyboardType = keyboardType
        }
        backgroundColor = style.backgroundColor ?? .clear
    }
}

// MARK: - Style + Customizing
extension TextField.Style {
    @discardableResult
    func placeholder(_ placeholder: String?) -> TextField.Style {
        var style = self
        style.placeholder = placeholder
        return style
    }
}

// MARK: - Style Presets
extension TextField.Style {
    static var text: TextField.Style {
        return TextField.Style(
            typeOfInput: .text
        )
    }

    static var address: TextField.Style {
        return TextField.Style(
            typeOfInput: .hexadecimal
        )
    }

    static var passphrase: TextField.Style {
        return TextField.Style(
            typeOfInput: .text,
            isSecureTextEntry: true
        )
    }

    static var privateKey: TextField.Style {
        return TextField.Style(
            typeOfInput: .hexadecimal,
            isSecureTextEntry: true
        )
    }

    static var number: TextField.Style {
        return TextField.Style(
            typeOfInput: .number,
            keyboardType: .numberPad
        )
    }
}
