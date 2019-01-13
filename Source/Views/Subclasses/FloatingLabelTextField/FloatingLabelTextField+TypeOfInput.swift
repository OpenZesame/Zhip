//
//  FloatingLabelTextField+TypeOfInput.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

extension FloatingLabelTextField {
    enum TypeOfInput {
        case number, hexadecimal, text
    }
}

extension FloatingLabelTextField.TypeOfInput {

    var characterSet: CharacterSet {
        switch self {
        case .number: return .decimalDigits
        case .hexadecimal: return .hexadecimalDigits
        case .text: return .alphanumerics
        }
    }
}
