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
    @Binding private var text: String
    @Binding private var pinCode: Pincode?
    @Binding private var errorMessage: String?
    private let digitCount: Int
    private let isSecure: Bool
    private let validColor: Color
    private let invalidColor: Color
    
    init(
        text: Binding<String>,
        pinCode: Binding<Pincode?>,
        errorMessage: Binding<String?>? = nil,
        digitCount: Int = 4,
        isSecure: Bool = true,
        validColor: Color = .teal,
        invalidColor: Color = .bloodRed
    ) {
        precondition(digitCount <= Pincode.maxLength)
        precondition(digitCount >= Pincode.minLength)
        self._text = text
        self.digitCount = digitCount
        self._pinCode = pinCode
        self.isSecure = isSecure
        self.invalidColor = invalidColor
        self.validColor = validColor
        self._errorMessage = errorMessage ?? .constant(nil)
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
        VStack(spacing: 0) {
            digitsView
            errorMessageView
        }
        .background(invisibleField)
        .padding()
    }
}

struct DigitAtIndex: Hashable {
    let digit: Digit?
    let index: Int
}

private extension PINField {

    @ViewBuilder
    var digitsView: some View {
        let digitsAtIndex: [DigitAtIndex] = text
                             .map({ String($0) })
                             .map({ Digit(string: $0)! })
                             .appending(nil, toCount: digitCount)
                             .enumerated().map {
                                 .init(digit: $0.element, index: $0.offset)
                             }
        HStack {
            ForEach(digitsAtIndex, id: \.self) { digitAtIndex in
                DigitView(
                    digitAtIndex: digitAtIndex,
                    isSecure: isSecure,
                    lineColor: $errorMessage.ifPresent { $0 ? invalidColor : validColor }
                )
            }
        }
    }
    
    @ViewBuilder
    var errorMessageView: some View {
        Text(errorMessage ?? " ")
            .font(.zhip.body)
            .foregroundColor(invalidColor)
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
