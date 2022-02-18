//
//  InputField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

struct InputField: View {
    
    @Binding private var text: String
    @Binding private var isValid: Bool
    
    private let prompt: String
    private let isSecure: Bool
    private let validationRules: [ValidationRule]
    
    init(
        prompt: String = "",
        text: Binding<String>,
        isValid: Binding<Bool>? = nil,
        isSecure: Bool = false,
        validationRules: [ValidationRule] = []
    ) {
        self.prompt = prompt
        self._text = text
        self._isValid = isValid ?? .constant(true)
        self.isSecure = isSecure
        self.validationRules = validationRules
    }
}

private let validColor: Color = .teal
private let invalidColor: Color = .bloodRed
    
extension InputField {
    var body: some View {
        HoverPromptTextField(
            prompt: prompt,
            text: $text,
            isValid: $isValid,
            config: .init(
                isSecure: isSecure,
                behaviour: .init(
                    validation: .init(
                        rules: validationRules
                    )
                ),
                appearance: .init(
                    colors: .init(
                        defaultColors: .init(
                            neutral: .asphaltGrey,
                            valid: validColor,
                            invalid: invalidColor
                        ),
                        textColors: .init(
                            defaultColors: .init(
                                neutral: .asphaltGrey,
                                valid: validColor,
                                invalid: invalidColor
                            ),
                            customized: .init(
                                field: .focusedAndNonFocused(.all(.white)),
                                promptWhenEmpty: .focusedAndNonFocused(neutral: .asphaltGrey)
                            )
                        )
                    ),
                    fonts: .init(field: Font.zhip.title, prompt: Font.zhip.hint)
                )
            ),
            leftView: { params in
                Circle()
                    .fill(params.isEmpty ? params.colors.neutral : (params.isValid ? params.colors.valid : params.colors.invalid))
                    .frame(size: 16)
            },
            rightView: { params in
                Group {
                if params.isSecureTextField && !params.isEmpty {
                    Button(action: {
                        withAnimation {
                            params.isRevealingSecrets.wrappedValue.toggle()
                        }
                    }) {
                        
                        Image(systemName: params.isRevealingSecrets.wrappedValue ? "eye.slash" : "eye").foregroundColor(params.isRevealingSecrets.wrappedValue ? Color.mellowYellow : Color.white)
                    }
                } else {
                    EmptyView()
                }
                }
            }
        )
    }
}

