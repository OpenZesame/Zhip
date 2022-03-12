//
//  DigitView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-21.
//

import SwiftUI

// MARK: - DigitView
// MARK: -
struct DigitView: View {
    let digitAtIndex: DigitAtIndex
    let isSecure: Bool
    let lineColor: Color
}

// MARK: - View
// MARK: -
extension DigitView {
    var body: some View {
        VStack(spacing: 0) {
            maybeDigit
            underline
        }.padding()
    }
    
}

// MARK: - Private
// MARK: -
private extension DigitView {
    
    var digitString: String {
        if let digit = digitAtIndex.digit {
            return isSecure ? "•" : String(describing: digit.rawValue)
        } else {
            // N.B. a single space, not the empty string. An UGLY hack to
            // enforce same size.
            return " "
        }
    }
    
    @ViewBuilder
    var maybeDigit: some View {
        Text(digitString)
            .font(isSecure ? .zhip.bigBang : .zhip.impression)
    }
    
    var underline: some View {
        Rectangle()
            .fill(lineColor)
            .frame(
                minWidth: 10, maxWidth: .infinity,
                minHeight: lineHeight, maxHeight: lineHeight,
                alignment: .center
            )
    }
    
}
private let lineHeight: CGFloat = 3
