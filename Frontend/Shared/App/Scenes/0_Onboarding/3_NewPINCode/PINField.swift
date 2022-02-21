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
        VStack {
            invisibleField.background(Color.red)
            digitsView
        }
    }
}

private extension PINField {
    enum Field {
        case invisibleField
    }
    
    var digitsView: some View {
        // ======= DELETE ME =======
        Group {
            if let pin = pinCode {
                Text("PIN: '\(pin.digits.map({ String(describing: $0) }).joined(separator: ""))'")
            } else {
                Text("No pin set")
            }
        }.font(.zhip.impression)
        // ======= DELETE ME =======
    }
    
    var invisibleField: some View {
        HoverPromptTextField(
            prompt: "",
            text: $text,
            config: .init(
                isSecure: false,
                behaviour: .init(
                    validation: .init(
                        rules: [
                            ValidateInputRequirement.minimumLength(of: Pincode.minLength),
                            ValidateInputRequirement.maximumLength(of: Pincode.maxLength)
                        ]
                    ),
                    characterRestriction: .onlyContains(whitelisted: .decimalDigits),
                    becomeFirstResponseOnAppear: true
                ),
                appearance: .init(
                    colors: .init(
                        defaultColors: .init(
                            neutral: .clear,
                            valid: .clear,
                            invalid: .clear
                        ),
                        textColors: .init(
                            defaultColors: .init(
                                neutral: .clear,
                                valid: .clear,
                                invalid: .clear
                            ),
                            customized: .init(
                                field: .focusedAndNonFocused(.all(.clear)),
                                promptWhenEmpty: .focusedAndNonFocused(neutral: .clear)
                            )
                        )
                    )
                )
            )
        )
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 50, alignment: .center)
        .accentColor(Color.clear)
        .onChange(of: text, perform: {
            pinCode = Pincode(text: $0)
        })
//        .onAppear(perform: {
//#if DEBUG
//            let hardcodedText = "1234"
//            self.text = hardcodedText
//#endif
//        })
    }
}
