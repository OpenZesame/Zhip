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
    @Binding private var isLoading: Bool
    init(
        isLoading: Binding<Bool>? = nil,
        cornerRadius: CGFloat = Self.defaultCornerRadius
    ) {
        self._isLoading = isLoading ?? .constant(false)
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                ActivityIndicator()
//                    .frame(size: CGSize(width: 200, height: 200))
                    .frame(maxHeight: 30)
                    .foregroundColor(.white)
            } else {
                configuration.label
                    .font(.zhip.callToAction)
                    .foregroundColor(isEnabled ? Color.white : .silverGrey)
                
            }
        }.frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color.teal : .asphaltGrey)
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
            .font(.zhip.callToAction)
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
    static func primary(
        isLoading: Binding<Bool>? = nil,
        cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius
    ) -> PrimaryButtonStyle {
        .init(isLoading: isLoading, cornerRadius: cornerRadius)
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
    static func secondary(cornerRadius: CGFloat) -> Self {
        .init(cornerRadius: cornerRadius)
    }
    
}

struct HallowButtonStyle: ButtonStyle {
        
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    init(
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius
    ) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zhip.callToAction)
            .padding([.leading, .horizontal])
            .padding([.bottom, .top], 8)
            .frame(idealWidth: 136, idealHeight: 44)
            .background(Color.clear)
            .foregroundColor(.teal)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.teal, lineWidth: borderWidth)
            )

    }
}

extension ButtonStyle where Self == HallowButtonStyle {

    static var hollow: Self {
        .hollow(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }

    static func hollow(cornerRadius: CGFloat) -> Self {
        .init(cornerRadius: cornerRadius)
    }
}
