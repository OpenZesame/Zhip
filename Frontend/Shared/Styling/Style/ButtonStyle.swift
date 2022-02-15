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


struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    private let cornerRadius: CGFloat
    init(cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius) {
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color.clear : .teal)
            .foregroundColor(isEnabled ? Color.teal : .silverGrey)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    /// A button style that applies the call to the **primary** action of the
    /// current screen, rounded with the default corner radious.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
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

extension ButtonStyle where Self == SecondaryButtonStyle {
    
    /// A button style that applies the call to the **secondary** action of the
    /// current screen, rounded with the default corner radious.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static var secondary: SecondaryButtonStyle {
        Self.secondary(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }
    
    /// A button style that applies the call to the **secondary** action of the
    /// current screen.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static func secondary(cornerRadius: CGFloat) -> SecondaryButtonStyle {
        .init(cornerRadius: cornerRadius)
    }
    
}
