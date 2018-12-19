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
        case number, hexadecimal, text
    }
    let typeOfInput: TypeOfInput

    init(type: TypeOfInput) {
        self.typeOfInput = type
        super.init(frame: .zero)
        self.delegate = self
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

// MARK: TextField + Styling
extension TextField {
    @discardableResult
    func withStyle<F>(_ style: UITextField.Style, customize: ((UITextField.Style) -> UITextField.Style)? = nil) -> F where F: UITextField {
        translatesAutoresizingMaskIntoConstraints = false
        apply(style: style)
        guard let field = self as? F else { incorrectImplementation("Bad cast") }
        return field
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

        // Dont allow pasting of non numbers
        guard typeOfInput.characterSet.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
        return true
    }
}

extension TextField.TypeOfInput {
    var characterSet: CharacterSet {
        switch self {
        case .number: return .decimalDigits
        case .hexadecimal: return .hexadecimalDigits
        case .text: return .alphanumerics
        }
    }
}
