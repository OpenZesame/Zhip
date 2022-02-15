//
//  HoverPromptTextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

//private enum InputState {
//    case valid
//    case empty
//    case invalid
//}

public struct HoverPromptTextField: View {
    
    /// The text the user has inputted.
    @Binding private var text: String
    
    /// Config of appearance and behaviour.
    let config: Config

    /// A prompt of what is being asked for, that will move up above the
    /// textfield when inputted text is non empty.
    let prompt: String
    
    var isEmpty: Bool {
        text.isEmpty
    }
    
//    private var inputState: InputState {
//        if isEmpty {
//            return .empty
//        } else {
//            return isValid ? .valid : .invalid
//        }
//    }
    
    /// If the `text` is valid according to validation rules.
    @State private var isValid = true
    
    init(
        prompt: String,
        text: Binding<String>,
        config: Config = .default
    ) {
        self.prompt = prompt
        self._text = text
        self.config = config
    }
    
    public var body: some View {
        VStack {
            maybeHoveringPrompt()
            wrappedField()
                .modifier(
                    PlaceholderStyle(
                        placeholder: prompt,
                        shownWhen: isEmpty
                    )
                )
        }.frame(height: 64, alignment: .leading)
    }
    
    @ViewBuilder func maybeHoveringPrompt() -> some View {
        if !isEmpty {
            Text(prompt)
                .foregroundColor(textColor(of: \.hoveringPrompt))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder func wrappedField() -> some View {
        Group {
            if config.isSecure {
                SecureField(text: $text) {
                    EmptyView() // No `title` view
                }
            } else {
                TextField(text: $text) {
                    EmptyView() // No `title` view
                }
            }
        }
        .foregroundColor(textColor(of: \.field))
        .focused($isFocused)
        .onChange(of: isFocused) {
            assert($0 == isFocused)
            print("isFocused=\(isFocused)")
        }
    }
    
    @FocusState private var isFocused: Bool
    
    private func textColor<TextColors: FieldTextColor>(
        of keyPath: KeyPath<Config.Appearance.Colors.TextColors, TextColors>
    ) -> Color {
        let colors = config.appearance.colors.textColors[keyPath: keyPath]
        let colorsDependingOnValidationState = isFocused ? colors.focused : colors.notFocused
        if isEmpty {
            return colorsDependingOnValidationState.empty
        } else {
            return isValid ? colorsDependingOnValidationState.valid : colorsDependingOnValidationState.invalid
        }
    }
    
}

public struct PlaceholderStyle: ViewModifier {
    var placeholder: String
    var showPlaceholder: Bool
    
    public init(
        placeholder: String,
        shownWhen showPlaceholder: Bool
    ) {
        self.placeholder = placeholder
        self.showPlaceholder = showPlaceholder
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
            }
            content
            .foregroundColor(Color.white)
        }
    }
}

public extension HoverPromptTextField {
    
    struct Config: Equatable {
        public let isSecure: Bool
        public let appearance: Appearance
        public let behaviour: Behaviour
    }
}

public extension HoverPromptTextField.Config {
    
    static var `default`: Self { .init(
        isSecure: false,
        appearance: .default,
        behaviour: .default
    ) }
    
    struct Appearance: Equatable {
        public let colors: Colors
    }
}

public extension HoverPromptTextField.Config.Appearance {
    static var `default`: Self { .init(colors: .default) }
    
    struct Colors: Equatable {
        /// The color of the text being typed disregarding of validation state
        public let textColors: TextColors
    }
    
}
public extension HoverPromptTextField.Config.Appearance.Colors {
    static let `default`: Self = .init(textColors: .default)
    
    struct TextColors: Equatable {
        public let field: Field
        public let hoveringPrompt: HoveringPrompt
    }
    
    struct DependingOnValidationState: Equatable {
        public static let allWhite: Self = .init(empty: .white, valid: .white, invalid: .white)
        public static let allBlack: Self = .init(empty: .black, valid: .black, invalid: .black)
        public static let `default`: Self = .init(empty: .white, valid: .green, invalid: .red)
        
        public let empty: Color
        public let valid: Color
        public let invalid: Color
    }
    
}

public protocol FieldTextColor {
    var focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { get }
    var notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { get }
}

public extension HoverPromptTextField.Config.Appearance.Colors.TextColors.HoveringPrompt {
    /// The hovering prompt is only visible when field is focused.
    var focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { dependingOnValidationState }
    /// The hovering prompt is only visible when field is focused.
    var notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { focused }
}

public extension HoverPromptTextField.Config.Appearance.Colors.TextColors {
    
    static let `default`: Self = .init(field: .default, hoveringPrompt: .default)
    
    struct Field: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .allWhite, notFocused: .allWhite)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    struct HoveringPrompt: Equatable, FieldTextColor {
        public static let `default`: Self = .init(dependingOnValidationState: .default)
        public let dependingOnValidationState: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
}

public extension HoverPromptTextField.Config {
    struct Behaviour: Equatable {
        public let validation: Validation
    }
}

public extension HoverPromptTextField.Config.Behaviour {
    enum Validation: Equatable {
        static var `default`: Self { .lazily }
        
        /// Validates as late as possible, i.e. when a field loses focus as opposed
        /// to directly when text is being typed.
        case lazily
        
        /// Validates as eagerly as possible, i.e. as soon as a user focuses a field
        /// the text gets validated, which results in validation errors being displayed
        /// directly
        case eagerly
    }
    static var `default`: Self { .init(validation: .default) }
}

//internal struct DynamicColor: ViewModifier {
//    private let colors: HoverPromptTextField.Config.Appearance.Colors
//
//    internal init(
//        colors: HoverPromptTextField.Config.Appearance.Colors,
//        logic: () -> Color
//    ) {
//        self.colors = colors
//    }
//
//    public func body(content: Content) -> some View {
//        content
//            .foregroundColor(Color.white)
//    }
//}
