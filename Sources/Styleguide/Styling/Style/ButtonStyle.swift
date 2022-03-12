//
//  ButtonStyle.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    public static let defaultCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat
    @Binding private var isLoading: Bool

	public init(
        isLoading: Binding<Bool>? = nil,
        cornerRadius: CGFloat = Self.defaultCornerRadius
    ) {
        self._isLoading = isLoading ?? .constant(false)
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
//        Group {
//            if isLoading {
//                ActivityIndicator()
//                    .frame(size: 30)
//                    .foregroundColor(.white)
//            } else {
//                configuration.label
//                    .font(.zhip.callToAction)
//                    .foregroundColor(isEnabled ? Color.white : .silverGrey)
//
//            }
//        }.frame(maxWidth: .infinity, idealHeight: 50)
//            .padding()
//            .background(isEnabled ? Color.turquoise : .asphaltGrey)
//            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
		Text("CODE COMMENTED OUT!")
    }
}


public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    private let cornerRadius: CGFloat
    
	public init(cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius) {
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zhip.callToAction)
            .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color.clear : .turquoise)
            .foregroundColor(isEnabled ? Color.turquoise : .silverGrey)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {

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

public extension ButtonStyle where Self == SecondaryButtonStyle {
    
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

public struct HallowButtonStyle: ButtonStyle {
        
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    
	public init(
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius
    ) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zhip.callToAction)
            .padding([.leading, .horizontal])
            .padding([.bottom, .top], 8)
            .frame(idealWidth: 136, idealHeight: 44)
            .background(Color.clear)
            .foregroundColor(.turquoise)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.turquoise, lineWidth: borderWidth)
            )

    }
}

public extension ButtonStyle where Self == HallowButtonStyle {

    static var hollow: Self {
        .hollow(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }

    static func hollow(cornerRadius: CGFloat) -> Self {
        .init(cornerRadius: cornerRadius)
    }
}
