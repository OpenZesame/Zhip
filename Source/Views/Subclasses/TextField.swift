//
//  TextField.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

final class TextField: SkyFloatingLabelTextField {
    enum TypeOfInput {
        case decimal, hexadecimal, text
    }
    let typeOfInput: TypeOfInput

    convenience init(placeholder: CustomStringConvertible, type: TypeOfInput) {
        self.init(type: type)
        self.placeholder = placeholder.description
    }

    init(type: TypeOfInput) {
        self.typeOfInput = type
        super.init(frame: .zero)
        self.delegate = self
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

// MARK: TextField + Styling
extension TextField {
    func withStyle(_ style: Style) -> TextField {
        translatesAutoresizingMaskIntoConstraints = false
        apply(style: style)
        return self
    }
}

// MARK: UITextFieldDelegate
extension TextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessage = nil
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Always allow erasing of digit
        guard !string.isBackspace else { return true }
        if let decimalSeparator = Locale.current.decimalSeparator, typeOfInput == .decimal, string == decimalSeparator {
            guard let text = textField.text else { return true }

            // Prevent double decimal separators
            return !text.contains(decimalSeparator)
        }

        // Dont allow pasting of non numbers
        guard typeOfInput.characterSet.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
        return true
    }
}

extension TextField.TypeOfInput {
    var characterSet: CharacterSet {
        switch self {
        case .decimal: return .decimalDigits
        case .hexadecimal: return .hexadecimalDigits
        case .text: return CharacterSet.alphanumerics
        }
    }
}
