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
    
    public static func all(_ color: Color) -> Self {
        .init(neutral: color, valid: color, invalid: color)
    }
}


public extension HoverPromptTextFieldConfig {
    
    /// Contains all configurations relating to the appearance of this view.
    struct Appearance: Equatable {
        
        /// Height of the line view depending on state.
        public let lineHeight: LineHeight

        /// Colors for all subviews of this view.
        public let colors: Colors
        
        public struct Fonts: Equatable {
            public let field: Font
            public let prompt: Font
            public let error: Font
            public let requirements: Font
            public init(
                field: Font = .body,
                prompt: Font = .subheadline,
                error: Font = .caption,
                requirements: Font = .caption2
            ) {
                self.field = field
                self.prompt = prompt
                self.error = error
                self.requirements = requirements
            }
            public static let `default`: Self = .init()
        }
        
        public let fonts: Fonts
        
        public init(
            lineHeight: LineHeight = .default,
            colors: Colors,
            fonts: Fonts = .default
        ) {
            self.lineHeight = lineHeight
            self.colors = colors
            self.fonts = fonts
        }
    }
}

public extension HoverPromptTextFieldConfig.Appearance {
    
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
        
        public init(
            defaultColors: DefaultColors = .default,
            textColors: TextColors? = nil, // will use `defaultColors` if nil
            lineColors: DependingOnValidationState = .default
        ) {
            self.defaultColors = defaultColors
            self.textColors = textColors ?? .init(defaultColors: defaultColors, customized: .default)
            self.lineColors = lineColors
        }
    }
    
}
public extension HoverPromptTextFieldConfig.Appearance.Colors {
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
        
        public init(
            defaultColors: DefaultColors = .default,
            customized: Customized = .default
        ) {
            self.defaultColors = defaultColors
            self.customized = customized
        }
      
        public struct Customized: Equatable {
            public let field: Field
            public let hoveringPrompt: HoveringPrompt
            public let promptWhenEmpty: PromptWhenEmpty
            public let requirmentLabel: RequirmentLabel
            public let errorLabel: ErrorLabel
            
            public init(
                field: Field = .default,
                hoveringPrompt: HoveringPrompt = .default,
                promptWhenEmpty: PromptWhenEmpty = .default,
                requirmentLabel: RequirmentLabel = .default,
                errorLabel: ErrorLabel = .default
            ) {
                self.field = field
                self.hoveringPrompt = hoveringPrompt
                self.promptWhenEmpty = promptWhenEmpty
                self.requirmentLabel = requirmentLabel
                self.errorLabel = errorLabel
            }
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
        
        public static func all(_ color: Color) -> Self {
            .init(.all(color))
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
 
    var focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState { get }
    var notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState { get }
}

public protocol FieldTextColorsDependingOnFocusedOrNot: FieldTextColor {
    init(
        focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState,
        notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
    )
}

public extension FieldTextColorsDependingOnFocusedOrNot {
    static func focusedAndNonFocused(
        neutral: Color? = nil,
        valid: Color? = nil,
        invalid: Color? = nil
    ) -> Self {
        let colors = HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState(
            neutral: neutral,
            valid: valid,
            invalid: invalid
        )
        return Self.focusedAndNonFocused(colors)
    }
    
    static func focusedAndNonFocused(
        _ colors: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
    ) -> Self {
        return Self.init(focused: colors, notFocused: colors)
    }
}

public extension HoverPromptTextFieldConfig.Appearance.Colors.TextColors.Customized.HoveringPrompt {
    /// The hovering prompt is only visible when field is focused.
    var focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState { dependingOnValidationState }
    /// The hovering prompt is only visible when field is focused.
    var notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState { focused }
}

public extension HoverPromptTextFieldConfig.Appearance.Colors.TextColors.Customized {
    
    static let `default`: Self = .init(
        field: .default,
        hoveringPrompt: .default,
        promptWhenEmpty: .default,
        requirmentLabel: .default,
        errorLabel: .default
    )
    
    struct Field: Equatable, FieldTextColorsDependingOnFocusedOrNot {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        
        public init(
            focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState,
            notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
            
        ) {
            self.focused = focused
            self.notFocused = notFocused
        }
    }
    
    struct HoveringPrompt: Equatable, FieldTextColor {
        public static let `default`: Self = .init(dependingOnValidationState: .default)
        public let dependingOnValidationState: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        
        public init(
            dependingOnValidationState: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        ) {
            self.dependingOnValidationState = dependingOnValidationState
        }
    }
    
    struct PromptWhenEmpty: Equatable, FieldTextColorsDependingOnFocusedOrNot {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        
        public init(
            focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState,
            notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
            
        ) {
            self.focused = focused
            self.notFocused = notFocused
        }
    }
    
    /// Not always used. Only shown if you pass in any `ValidateInputRequirement` as rules.
    struct RequirmentLabel: Equatable, FieldTextColorsDependingOnFocusedOrNot {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        
        public init(
            focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState,
            notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
            
        ) {
            self.focused = focused
            self.notFocused = notFocused
        }
    }
    
    /// Not always used, if no validation rules are passed to field initializer an error is never shown.
    struct ErrorLabel: Equatable, FieldTextColorsDependingOnFocusedOrNot {
        public static let `default`: Self = .init(focused: .default, notFocused: .default)
        public let focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        public let notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
        
        public init(
            focused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState,
            notFocused: HoverPromptTextFieldConfig.Appearance.Colors.DependingOnValidationState
            
        ) {
            self.focused = focused
            self.notFocused = notFocused
        }
    }
}
