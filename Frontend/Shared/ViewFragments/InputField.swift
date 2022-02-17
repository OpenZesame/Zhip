//
//  InputField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

struct InputField: View {
    
    var prompt: String = ""
    @Binding var text: String
    var isSecure: Bool = false
    var validationRules: [ValidationRule] = []
    
    private let validColor: Color = .teal
    private let invalidColor: Color = .bloodRed
    
    var body: some View {
        HoverPromptTextField(
            prompt: prompt,
            text: $text,
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

