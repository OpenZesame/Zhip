//
//  HoverPromptTextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

public struct HoverPromptTextField: View {
    
    /// The text the user has inputted.
    @Binding private var text: String
    
    /// Config of appearance and behaviour.
    public fileprivate(set) var config: Config

    /// A prompt of what is being asked for, that will move up above the
    /// textfield when inputted text is non empty.
    let prompt: String
    
    /// If the `text` equals the empty string.
    var isEmpty: Bool {
        text.isEmpty
    }

    /// The error messages produces by running the validation rules against
    /// the `text`. The value `nil` means that `text` is **valid**.
    @State private var errorMessages = [String]?.none
    
    /// If the `text` validates against the validation rules. Will always be
    /// true, i.e. valid, if the valdiation rule set provided was empty.
    private var isValid: Bool {
        errorMessages == nil
    }
    
//    public func addValidation(rule: Config.Behaviour.Validation.Rule?) -> Self {
//        guard let rule = rule else { return self }
//        config.behaviour.validation.rules.append(rule)
//        return self
//    }
    
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
            
            switch config.behaviour.validationTriggering {
            case .eagerErrorEagerOK:
                validate()
            case .lazyErrorEagerOK:
                if isFocused {
                    onlyIfOKChangeValidationStateToOK()
                } else {
                    validate()
                }
            }
        }.onChange(of: text) {
            assert($0 == text)
            print("Text: \(text)")
            switch config.behaviour.validationTriggering {
            case .lazyErrorEagerOK:
                onlyIfOKChangeValidationStateToOK()
            case .eagerErrorEagerOK:
                 validate()
            }
        }
    }
    
    @FocusState private var isFocused: Bool

}

private extension HoverPromptTextField {
    
    /// Returns the text color of field or prompt given current state.
    func textColor<TextColors: FieldTextColor>(
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
    
    /// The value `nil` means that `text` **is valid**. Else it contains a list
    /// of error messages
    func validationResult() -> [String]? {
        let errorMessages: [String] = config.behaviour.validation.rules.compactMap { rule in
            rule.validate(text)
        }
        guard !errorMessages.isEmpty else {
            // text is valid
            return nil
        }
        
        // text is invalid, and here are all the errors.
        return errorMessages
    }
    
    /// Updates validation state by performing validation
    func validate() {
        errorMessages = validationResult()
    }
    
    func onlyIfOKChangeValidationStateToOK() {
        let errors = validationResult()
        guard errors == nil else {
            // Invalid, but don't change state to error.
            return
        }
        // Validation passes, all OK => change state to OK
        errorMessages = nil
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
    
    struct Config {
        public let isSecure: Bool
        public let appearance: Appearance
        public fileprivate(set) var behaviour: Behaviour
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
    struct Behaviour {
        public let validationTriggering: ValidationTriggering
        public fileprivate(set) var validation: Validation
    }
}

public extension HoverPromptTextField.Config.Behaviour {
    
    struct Validation {
        
        public fileprivate(set) var rules: [Rule]
        public init(rules: [Rule]) {
            self.rules = rules
        }
    }
    
    enum ValidationTriggering: Equatable {
        static var `default`: Self { .lazyErrorEagerOK }
        
        /// Validates as late as possible, i.e. when a field loses focus as opposed
        /// to directly when text is being typed.
        case lazyErrorEagerOK
        
        /// Validates as eagerly as possible, i.e. as soon as a user focuses a field
        /// the text gets validated, which results in validation errors being displayed
        /// directly
        case eagerErrorEagerOK
    }
    static var `default`: Self { .init(validationTriggering: .default, validation: .init(rules: [])) }
}

public extension HoverPromptTextField.Config.Behaviour.Validation {
    struct Rule {
        public typealias CurrentText = String
        public typealias ErrorMessage = String
        
        /// A validation function: valdiates current text and returns an error
        /// message if the text is invalid. Returning `nil` indicates that the
        /// input **is valid**.
        public typealias Validate = (_ currentText: CurrentText) -> ErrorMessage?
        
        public let validate: Validate
        public init(validate: @escaping Validate) {
            self.validate = validate
        }
    }
}

public extension HoverPromptTextField.Config.Behaviour.Validation.Rule {
    struct TooShortViolation: Equatable {
        public let minimumLength: Int
        public let actualLength: Int
        
        /// The number of too few characters the text have.
        public var dearthCharacterCount: Int {
            minimumLength - actualLength
        }
        
        internal init(minimumLength: Int, actualLength: Int) {
            precondition(actualLength < minimumLength)
            self.minimumLength = minimumLength
            self.actualLength = actualLength
        }
    }
    struct TooLongViolation: Equatable {
        public let maximumLength: Int
        public let actualLength: Int
        
        /// The number of too many characters the text have.
        public var excessCharacterCount: Int {
            actualLength - maximumLength
        }
        public init(maximumLength: Int, actualLength: Int) {
            precondition(actualLength > maximumLength)
            self.maximumLength = maximumLength
            self.actualLength = actualLength
        }
    }
    
    static func minimumLength(
        of minimumLength: Int,
        _ errorMessage: @escaping (TooShortViolation) -> String
    ) -> Self {
        Self { text in
            guard text.count >= minimumLength else {
                return errorMessage(
                    TooShortViolation(
                        minimumLength: minimumLength,
                        actualLength: text.count
                    )
                )
            }
            return nil // valid
        }
    }
    
    static func minimumLength(
        of minimumLength: Int
    ) -> Self {
        Self.minimumLength(of: minimumLength) { tooShortViolation in
            "\(tooShortViolation.dearthCharacterCount) too few."
        }
    }
    
    static func maximumLength(
        of maximumLength: Int,
        _ errorMessage: @escaping (TooLongViolation) -> String
    ) -> Self {
        Self { text in
            guard text.count <= maximumLength else {
                return errorMessage(
                    TooLongViolation(
                        maximumLength: maximumLength,
                        actualLength: text.count
                    )
                )
            }
            return nil // valid
        }
    }
    
    static func maximumLength(
        of maximumLength: Int
    ) -> Self {
        Self.maximumLength(of: maximumLength) { tooLongViolation in
            "\(tooLongViolation.excessCharacterCount) too long."
        }
    }
    
}
