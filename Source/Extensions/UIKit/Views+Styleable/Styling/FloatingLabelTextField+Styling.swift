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

    static var address: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .hexadecimal
        )
    }

    static var passphrase: FloatingLabelTextField.Style {
        return FloatingLabelTextField.Style(
            typeOfInput: .text,
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
}
