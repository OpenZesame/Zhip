//
//  ButtonStyle.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    static let defaultCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat
    init(cornerRadius: CGFloat = Self.defaultCornerRadius) {
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color.teal : .asphaltGrey)
            .foregroundColor(isEnabled ? Color.white : .silverGrey)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: PrimaryButtonStyle {
        Self.primary(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }
    
    /// A button style that applies the call to the **primary** action of the
    /// current screen.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static func primary(cornerRadius: CGFloat) -> PrimaryButtonStyle {
        .init(cornerRadius: cornerRadius)
    }
}
