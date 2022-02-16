//
//  HoverPromptTextField+Appearance.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

/// A global default of colors for the three different states `neutral`, `valid`, `invalid`.
///
/// The three states are:
/// - `neutral`: When `text` is neither invalid nor valid, e.g. empty
/// - `valid`: When `text` is valid (according to some validation)
/// - `invalid`: When `text` did not pass valdiation.
public struct DefaultColors: Equatable {
    
    public static let `default` = Self(neutral: Self.defaultNeutral, valid: Self.defaultValid, invalid: Self.defaultInvalid)
    
    public static let defaultNeutral = Color.gray
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
    
    /// Contains all configurations relating to the appearance of this view.
    struct Appearance: Equatable {
        
        /// Height of the line view depending on state.
        public let lineHeight: LineHeight

        /// Colors for all subviews of this view.
        public let colors: Colors
        
        public init(
            lineHeight: LineHeight = .default,
            colors: Colors
        ) {
            self.lineHeight = lineHeight
            self.colors = colors
        }
    }
}

public extension HoverPromptTextField.Config.Appearance {
    
    static var `default`: Self { .init(lineHeight: .default, colors: .default) }

    struct LineHeight: Equatable {
        
        public struct DependingOnState: Equatable {
         
            public let valid: CGFloat
            public let invalid: CGFloat
            public let neutral: CGFloat
            public init(
                valid: CGFloat,
                invalid: CGFloat,
                neutral: CGFloat
            ) {
                self.valid = valid
                self.invalid = invalid
                self.neutral = neutral
            }
            
            /// Same height of line, independent of state.
            public init(height: CGFloat) {
                self.init(valid: height, invalid: height, neutral: height)
            }
        }
        
        public let focused: DependingOnState
        public let notFocused: DependingOnState
        
        public static let defaultHeightWhenFocused: CGFloat = 4
        public static let defaultHeightWhenNotFocused: CGFloat = 2
        

        public init(
            focused: DependingOnState,
            notFocused: DependingOnState
        ) {
            self.focused = focused
            self.notFocused = notFocused
        }
        
        public static let `default` = Self.init(
            focused: .init(height: Self.defaultHeightWhenFocused),
            notFocused: .init(height: Self.defaultHeightWhenNotFocused)
        )
    }
    
    struct Colors: Equatable {
        
        /// Colors which will be used as global defaults in the abscene of
        /// customized colors for a given subview for a given state.
        public let defaultColors: DefaultColors
        
        /// The color of the text being typed disregarding of validation state
        public let textColors: TextColors
        
        /// The color of the line under the input field.
        public let lineColors: DependingOnValidationState
    }
    
}
public extension HoverPromptTextField.Config.Appearance.Colors {
    static let `default`: Self = .init(
        defaultColors: .default,
        textColors: .default,
        lineColors: .default
    )
    
    
    /// Customized colors for texts. For any `nil` value, the `defaultColors` of `Appearance.Colors`
    /// property will be used.
    struct TextColors: Equatable {
        public static let `default`: Self = .init(
            defaultColors: .init(neutral: .white),
            customized: .default)
        
        public let defaultColors: DefaultColors
        public let customized: Customized
      
        public struct Customized: Equatable {
            public let field: Field
            public let hoveringPrompt: HoveringPrompt
            public let promptWhenEmpty: PromptWhenEmpty
            public let requirmentLabel: RequirmentLabel
            public let errorLabel: ErrorLabel
        }
    }
    
    
    struct DependingOnValidationState: Equatable {
        public static let `default`: Self = .init(neutral: nil, valid: nil, invalid: nil)
        
        public let neutral: Color?
        public let valid: Color?
        public let invalid: Color?
        
        public init(
            neutral: Color? = nil,
            valid: Color? = nil,
            invalid: Color? = nil
        ) {
            self.neutral = neutral
            self.valid = valid
            self.invalid = invalid
        }
        
        public init(
            _ colors: DefaultColors
        ) {
            self.init(
                neutral: colors.neutral,
                valid: colors.valid,
                invalid: colors.invalid
            )
        }
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
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    struct HoveringPrompt: Equatable, FieldTextColor {
        public static let `default`: Self = .init(dependingOnValidationState: .default)
        public let dependingOnValidationState: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    struct PromptWhenEmpty: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextField.Config.Appearance.Colors.DependingOnValidationState
    }
    
    /// Not always used. Only shown if you pass in any `ValidateInputRequirement` as rules.
    struct RequirmentLabel: Equatable, FieldTextColor {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
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
