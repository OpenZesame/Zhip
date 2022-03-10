//
//  PINField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-20.
//

import SwiftUI
import ZhipEngine

// MARK: - PINField
// MARK: -
public struct PINField: StatefulViewFragment {
    
    @StateObject var viewModel: ViewModel = .init()
    
    @Binding private var text: String
    @Binding private var pinCode: Pincode?

    private let errorMessage: String?
    
    private let digitCount: Int
    private let isSecure: Bool
    private let validColor: Color
    private let invalidColor: Color
    
    public init(
        text: Binding<String>,
        pinCode: Binding<Pincode?>,
        errorMessage: String? = nil,
        digitCount: Int = 4,
        isSecure: Bool = true,
        validColor: Color = .turquoise,
        invalidColor: Color = .bloodRed
    ) {
        precondition(digitCount <= Pincode.maxLength)
        precondition(digitCount >= Pincode.minLength)

        self._text = text
        self._pinCode = pinCode

        self.digitCount = digitCount
        self.isSecure = isSecure
        self.invalidColor = invalidColor
        self.validColor = validColor
        self.errorMessage = errorMessage
    }
}

// MARK: - StatefulViewFragment
// MARK: -
public extension PINField {
    typealias ViewModel = PINFieldViewModel
    var __viewModelWitness: StateObject<ViewModel> { self._viewModel }
    
}

// MARK: - View
// MARK: -
public extension PINField {
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0) {
            digitsView
                .modifier(ShakeEffect(x: viewModel.shakesLeft > 0 ? -15 : 0))
                .animation(
                    Animation
                        .easeInOut(duration: ViewModel.durationPerShake)
                        .repeatCount(ViewModel.shakeRepeatCount),
                    value: viewModel.shakesLeft // decreased by timer
                )
            errorMessageView
        }
        .background(invisibleField)
        .padding()
    }
}

// MARK: - Private
// MARK: -
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
                    lineColor: errorMessage != nil ? invalidColor : validColor
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
        // Criteria for when to set PIN code (when `text` of TextField changes)
        .onChange(of: text, perform: {
            let newPin = Pincode(text: String($0.prefix(digitCount)))
            if pinCode != newPin {
                pinCode = newPin
            }
        })
        // Criteria for when to trigger shake (when `self.errorMessage` is present)
        .onChange(of: errorMessage) { maybeErrorMsg in
            if maybeErrorMsg != nil {
                viewModel.shake()
            }
        }
        
    }
}

// MARK: - DigitAtIndex
// MARK: -
internal struct DigitAtIndex: Hashable {
    let digit: Digit?
    let index: Int
}


// MARK: - Pincode init
// MARK: -
extension Pincode {
    init?(text: String) {
        try? self.init(
            digits: text.compactMap { Digit(string: String($0)) }
        )
    }
}

public extension Array {
	func appending(_ element: Element, toCount targetCount: Int) -> Self {
		if count >= targetCount {
			return self
		}
		let suffix = [Element](repeating: element, count: targetCount - count)
		return self + suffix
	}
}
