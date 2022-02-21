//
//  PINField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-20.
//

import SwiftUI
import ZhipEngine
import Combine

// MARK: - PINField
// MARK: -
struct PINField: View {
    @State private var text = ""
    @State private var isValid = true
//    private let isValidSubject = CurrentValueSubject<Bool, Never>(false)
//    @Binding private var isValid: Bool
    @Binding private var pinCode: Pincode?
    
    init(pinCode: Binding<Pincode?>) {
        self._pinCode = pinCode
        
    }
}

extension Pincode {
    init?(text: String) {
        try? self.init(digits: text.compactMap { Digit(string: String($0)) })
    }
}

// MARK: - View
// MARK: -
extension PINField {
    var body: some View {
        
        InputField(
            prompt: "PIN",
            text: $text,
            isValid: $isValid,
            isSecure: false,
            characterRestriction: .onlyContains(whitelisted: .decimalDigits),
            validationRules: [
                ValidateInputRequirement.minimumLength(of: Pincode.minLength),
                ValidateInputRequirement.maximumLength(of: Pincode.maxLength)
            ]
        ).onChange(of: text, perform: {
            print("PINField - text: \($0)")
            pinCode = Pincode(text: $0)
        })
    }
}
