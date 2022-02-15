//
//  FloatingLabelTextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct AdvancedTextField: View {
    
    enum TextFieldType: String, Equatable {
        case secure, plain
    }
    
    @Binding var text: String
    
    @Binding private var isValid: Bool
    
    private let validation: TextFieldValidator?
    private let errorColor: Color
    private let emptyColor: Color
    private let validColor: Color
    private let validWithRemarkColor: Color
    private let textColor: Color
    private let placeholder: String
    let type: TextFieldType
    @State private var reveal: Bool = false
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        isValid: Binding<Bool>,
        type: TextFieldType = .plain,
        validation: TextFieldValidator? = nil,
        errorColor: Color = .bloodRed,
        emptyColor: Color = .silverGrey,
        validColor: Color = .teal,
        validWithRemarkColor: Color = .mellowYellow,
        textColor: Color = .white
    ) {
        self.type = type
        self.placeholder = placeholder
        self._text = text
        self._isValid = isValid
        self.validation = validation
        self.errorColor = errorColor
        self.emptyColor = emptyColor
        self.validColor = validColor
        self.validWithRemarkColor = validWithRemarkColor
        self.textColor = textColor
    }
    
    private let fieldHeight: CGFloat = 64
    private let circleSize: CGFloat = 16
    
    var body: some View {
        FloatingLabelTextField(
            $text,
            validationChecker: $isValid,
            placeholder: placeholder,
            editingChanged: { editingDidChange in
            }, commit: {
                // When leave focus or `return` key pressed.
            })
            .lineColor(validColor)
            .selectedLineColor(validColor)
            .titleColor(validColor)
            .selectedTitleColor(validColor)
            .selectedTextColor(textColor)
            .textColor(textColor)
            .shouldDisplayValidationErrorMessage(true) /// Display error message upon validation error
            .errorColor(errorColor) /// Sets the error color.
            .isSecureTextEntry(type == .secure && !reveal)
            .addValidation(validation)
            .leftView {
                Circle()
                    .fill(text.isEmpty ? Color.clear : ($isValid.wrappedValue ? validColor : errorColor))
                    .frame(width: circleSize, height: circleSize)
            }
            .rightView {
                if type == .secure {
                    Button(action: {
                        withAnimation {
                            reveal.toggle()
                        }
                        
                    }) {
                        Image(systemName: reveal ? "eye.slash" : "eye")
                    }
                }
            }.frame(height: fieldHeight).padding()
        
    }
    
}
