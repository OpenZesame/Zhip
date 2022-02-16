//
//  HoverPromptTextField+Appearance.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

public struct DefaultColors: Equatable {
    
    public static let `default` = Self(neutral: Self.defaultNeutral, valid: Self.defaultValid, invalid: Self.defaultInvalid)
    
    public static let defaultNeutral = Color.white
    public static let defaultValid = Color.green
    public static let defaultInvalid = Color.red
    
    public let neutral: Color
    public let valid: Color
    public let invalid: Color
    
    public init(
        neutral: Color = Self.defaultNeutral,
        valid: Color = Self.defaultValid,
        invalid: Color = Self.defaultInvalid
    ) {
        self.neutral = neutral
        self.valid = valid
        self.invalid = invalid
    }
}


public extension HoverPromptTextField.Config {
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
        
        static let `default`: Self = .init(defaultColors: .default, customizedColors: .default)
        
        public let defaultColors: DefaultColors
        public let customizedColors: Customized
        public struct Customized: Equatable {
            public let field: Field
            public let hoveringPrompt: HoveringPrompt
            public let promptWhenEmpty: PromptWhenEmpty
            public let requirmentLabel: RequirmentLabel
            public let errorLabel: ErrorLabel
        }
    }
    
    
    struct DependingOnValidationState: Equatable {
        public static let allWhite: Self = .init(neutral: .white, valid: .white, invalid: .white)
        public static let allBlack: Self = .init(neutral: .black, valid: .black, invalid: .black)
        public static let `default`: Self = .init(neutral: .white, valid: .green, invalid: .red)
        
        public let neutral: Color?
        public let valid: Color?
        public let invalid: Color?
    }
    
}

public protocol FieldTextColor {
    var focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { get }
    var notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { get }
}

public extension HoverPromptTextField.Config.Appearance.Colors.TextColors.Customized.HoveringPrompt {
    /// The hovering prompt is only visible when field is focused.
    var focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { dependingOnValidationState }
    /// The hovering prompt is only visible when field is focused.
    var notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState { focused }
}

public extension HoverPromptTextField.Config.Appearance.Colors.TextColors.Customized {
    
    static let `default`: Self = .init(
        field: .default,
        hoveringPrompt: .default,
        promptWhenEmpty: .default,
        requirmentLabel: .default,
        errorLabel: .default
    )
    
    struct Field: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .allWhite, notFocused: .allWhite)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    struct HoveringPrompt: Equatable, FieldTextColor {
        public static let `default`: Self = .init(dependingOnValidationState: .default)
        public let dependingOnValidationState: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    struct PromptWhenEmpty: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .allWhite, notFocused: .allWhite)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    /// Not always used. Only shown if you pass in any `ValidateInputRequirement` as rules.
    struct RequirmentLabel: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .allWhite, notFocused: .allWhite)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    /// Not always used, if no validation rules are passed to field initializer an error is never shown.
    struct ErrorLabel: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
}
