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
    private let digitCount: Int
    private let isSecure: Bool
    
    init(pinCode: Binding<Pincode?>, digitCount: Int = 4, isSecure: Bool = true) {
        precondition(digitCount <= Pincode.maxLength)
        precondition(digitCount >= Pincode.minLength)
        self.digitCount = digitCount
        self._pinCode = pinCode
        self.isSecure = isSecure
    }
}

extension Pincode {
    init?(text: String) {
        try? self.init(
            digits: text.compactMap { Digit(string: String($0)) }
        )
    }
}

// MARK: - View
// MARK: -
extension PINField {
    var body: some View {
        digitsView.background(invisibleField).padding()
    }
}

private extension PINField {
    
    /// These view models are ephemeral and should be regarded as such, stateless
    /// just used to provid uniqueness to each member. The data lies in the Digit
    /// passed in, and the actual state lies in this PINField's `text`.
    var digitViewModels: [DigitViewModel] {
             let digits = text
                     .map({ String($0) })
                     .map({ Digit(string: $0)! })
                     .appending(nil, toCount: digitCount)
        return digits.map { DigitViewModel(digit: $0) }
    }
    
    var digitsView: some View {
        HStack {
            ForEach(digitViewModels) { viewModel in
                DigitView(viewModel: viewModel, isSecure: isSecure)
            }
        }
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
                            ValidateInputRequirement.minimumLength(of: digitCount),
                        ]
                    ),
                    maxLength: digitCount,
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
            let newPin = Pincode(text: String($0.prefix(digitCount)))
            if pinCode != newPin {
                pinCode = newPin
                if let pin = pinCode {
                    print("✨ pin: \(String(describing: pin))")
                }
            }
         
        })
    }
}
