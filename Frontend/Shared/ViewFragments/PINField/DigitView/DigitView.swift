//
//  DigitView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-21.
//

import SwiftUI
import ZhipEngine

struct DigitView: View {
    @ObservedObject var viewModel: DigitViewModel
    let isSecure: Bool
    
    init(viewModel: DigitViewModel, isSecure: Bool = true) {
        self.viewModel = viewModel
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(spacing: 0) {
            maybeDigit
            underline
        }.padding()
    }

}
private extension DigitView {
    
    var digitString: String {
        if let digit = viewModel.digit {
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
//            .frame(height: )
    }
    
    var underline: some View {
        Rectangle()
            .fill(Color.teal)
            .frame(
                minWidth: 10, maxWidth: .infinity,
                minHeight: lineHeight, maxHeight: lineHeight,
                alignment: .center
            )
    }
    
}
private let lineHeight: CGFloat = 3
