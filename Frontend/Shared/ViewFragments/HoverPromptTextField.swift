//
//  HoverPromptTextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

public struct HoverPromptTextField<Title: View>: View {
    public typealias MakeTitle = () -> Title
    private let makeTitle: MakeTitle
    @Binding private var text: String
    let isSecure: Bool = true
    init(text: Binding<String>, _ makeTitle: @escaping MakeTitle) {
        self.makeTitle = makeTitle
        self._text = text
    }
    
    public var body: some View {
        wrappedField()
    }
    
    @ViewBuilder func wrappedField() -> some View {
        Group {
        if isSecure {
            SecureField(text: $text) {
                makeTitle()
            }
        } else {
            TextField(text: $text) {
                makeTitle()
            }
        }
        }.foregroundColor(.white)
    }
}

extension HoverPromptTextField where Title == Text {

    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.init(text: text) {
            Text(titleKey)
        }
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol {
        self.init(text: text) {
            Text(title)
        }
    }
}
