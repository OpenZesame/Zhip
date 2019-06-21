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
import TinyConstraints

extension FloatingLabelTextField {
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
extension FloatingLabelTextField {
    func apply(style: Style) {
        updateTypeOfInput(style.typeOfInput)
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
extension FloatingLabelTextField.Style {
    @discardableResult
    func placeholder(_ placeholder: String?) -> FloatingLabelTextField.Style {
        var style = self
        style.placeholder = placeholder
        return style
    }
}

// MARK: - Style Presets
extension FloatingLabelTextField.Style {
    static var text: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .text
        )
    }

    static var addressBech32OrHex: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .bech32OrHex
        )
    }

    static var password: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .password,
            isSecureTextEntry: true
        )
    }

    static var privateKey: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .hexadecimal,
            isSecureTextEntry: true
        )
    }

    static var number: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .number,
            keyboardType: .numberPad
        )
    }
    
    static var decimal: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .decimalWithSeparator,
            keyboardType: .decimalPad
        )
    }
}
