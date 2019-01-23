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
