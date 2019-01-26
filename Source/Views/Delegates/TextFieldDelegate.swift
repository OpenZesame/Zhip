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
