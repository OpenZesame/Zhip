//
//  TextFieldDelegate.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class TextFieldDelegate: NSObject {
    private let maxLength: Int?
    private var allowedCharacters: CharacterSet
    init(allowedCharacters: CharacterSet, maxLength: Int? = nil) {
        self.allowedCharacters = allowedCharacters
        self.maxLength = maxLength
    }
}

extension TextFieldDelegate {
    convenience init(type: FloatingLabelTextField.TypeOfInput = .text, maxLength: Int? = nil) {
        self.init(allowedCharacters: type.characterSet, maxLength: maxLength)
    }

    func setTypeOfInput( _ typeOfInput: FloatingLabelTextField.TypeOfInput) {
        allowedCharacters = typeOfInput.characterSet
    }
}

extension TextFieldDelegate: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Always allow erasing of digit
        guard !string.isBackspace else { return true }

        // Dont allow pasting of non numbers
        guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }

        guard let maxLength = maxLength else {
            return true
        }
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        // Dont allow pasting of strings longer than max length
        return newLength <= maxLength
    }
}
