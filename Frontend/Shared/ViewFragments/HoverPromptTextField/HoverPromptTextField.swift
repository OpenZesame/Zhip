//
//  HoverPromptTextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

public typealias HoverPromptTextFieldExtraViewsParams = (
    isFocused: Bool,
    isValid: Bool,
    isEmpty: Bool,
    isSecureTextField: Bool,
    colors: DefaultColors,
    isRevealingSecrets: Binding<Bool>
)

public struct HoverPromptTextField<LeftView: View, RightView: View>: View {
    public typealias Config = HoverPromptTextFieldConfig
    public typealias MakeViewParams = HoverPromptTextFieldExtraViewsParams
    
    /// The text the user has inputted.
    @Binding private var text: String

    /// If the input is valid or not. If no validation rule was provided, it is always valid.
    @Binding private var isValid: Bool
    
    /// Config of appearance and behaviour.
    public let config: HoverPromptTextFieldConfig

    /// A prompt of what is being asked for, that will move up above the
    /// textfield when inputted text is non empty.
    let prompt: String
    
    @FocusState private var isFocused: Bool

    /// The error messages produces by running the validation rules against
    /// the `text`. An empty array means `text` is **valid**.
    @State private var errorMessages = [String]() {
        didSet {
            isValid = isValid(given: errorMessages)
        }
    }
    
    @State private var isRevealingSecrets: Bool = false
    
    public typealias MakeLeftView = (HoverPromptTextFieldExtraViewsParams) -> LeftView
    public typealias MakeRightView = (HoverPromptTextFieldExtraViewsParams) -> RightView
    private let makeLeftView: MakeLeftView
    private let makeRightView: MakeRightView
   
    init(
        prompt: String,
        text: Binding<String>,
        isValid: Binding<Bool>? = nil,
        config: Config = .default,
        leftView makeLeftView: @escaping MakeLeftView,
        rightView makeRightView: @escaping MakeRightView
    ) {
        self.prompt = prompt
        self._text = text
        self._isValid = isValid ?? .constant(true)
        self.config = config
        self.makeLeftView = makeLeftView
        self.makeRightView = makeRightView
    }
}

// MARK: - Convenience init
// MARK: -
public extension HoverPromptTextField where RightView == EmptyView, LeftView == EmptyView {
    
     init(
         prompt: String,
         text: Binding<String>,
         isValid: Binding<Bool>? = nil,
         config: Config = .default
     ) {
         self.init(
            prompt: prompt,
            text: text,
            isValid: isValid,
            config: config,
            leftView: { _ in EmptyView() },
            rightView: { _ in EmptyView() }
         )
     }
}

public extension HoverPromptTextField where RightView == EmptyView {
    
     init(
         prompt: String,
         text: Binding<String>,
         isValid: Binding<Bool>? = nil,
         config: Config = .default,
         leftView makeLeftView: @escaping MakeLeftView
     ) {
         self.init(
            prompt: prompt,
            text: text,
            isValid: isValid,
            config: config,
            leftView: makeLeftView,
            rightView: { _ in EmptyView() }
         )
     }
}

public extension HoverPromptTextField where LeftView == EmptyView {
    
     init(
         prompt: String,
         text: Binding<String>,
         isValid: Binding<Bool>? = nil,
         config: Config = .default,
         rightView makeRightView: @escaping MakeRightView
     ) {
         self.init(
            prompt: prompt,
            text: text,
            isValid: isValid,
            config: config,
            leftView: { _ in EmptyView() },
            rightView: makeRightView
         )
     }
}


public extension HoverPromptTextField where RightView == EmptyView, LeftView == EmptyView {
    init(
        prompt: String,
        text: Binding<String>,
        isValid: Binding<Bool>? = nil,
        defaultColors: DefaultColors,
        isSecure: Bool = false,
        display: Config.Display = .default
    ) {
        self.init(
            prompt: prompt,
            text: text,
            isValid: isValid,
            config: .init(
                isSecure: isSecure,
                display: display,
                behaviour: .default,
                appearance: .init(
                    colors: .init(
                        defaultColors: defaultColors,
                        textColors: .init(
                            defaultColors: defaultColors,
                            customized: .default
                        ),
                        lineColors: .init(defaultColors)
                    )
                )
            )
        )
    }
}

// MARK: - Public
// MARK: -
public extension HoverPromptTextField {
    /// If the `text` equals the empty string.
    var isEmpty: Bool {
        text.isEmpty
    }
    
}


// MARK: - View (Body)
// MARK: -
public extension HoverPromptTextField {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            maybeHoveringPromptAndRequirements()
            
            HStack {
                
                makeLeftView(makeViewParams)
                
                ZStack(alignment: .leading) {
                    if isEmpty {
                        Text(prompt)
                            .foregroundColor(textColor(of: \.promptWhenEmpty))
                    }
                    wrappedField()
                }.font(font(of: \.field))
                
                makeRightView(makeViewParams)
            }
         
            
            line()
            
            if shouldDisplay(.errorMessage) {
                maybeError()
            }
        }
    }
}

// MARK: - Private
// MARK: -
private extension HoverPromptTextField {
    
    private var makeViewParams: MakeViewParams {
        (
            isFocused,
            isValid,
            isEmpty,
            isSecureTextField: config.isSecure,
            colors: config.appearance.colors.defaultColors,
            isRevealingSecrets: $isRevealingSecrets
        )
    }
    
    func shouldDisplay(_ subview: Config.Display) -> Bool {
        config.display.contains(subview)
    }
    
    func isValid(given errors: [String]) -> Bool {
        errors.isEmpty
    }
    
    /// An empty array means no requirements
    var inputRequirments: [ValidateInputRequirement] {
        config.behaviour.validation.rules.compactMap { $0 as? ValidateInputRequirement }
    }
    
    func font(of keyPath: KeyPath<Config.Appearance.Fonts, Font>) -> Font {
        // TODO add support for fonts depending on state here...
        return config.appearance.fonts[keyPath: keyPath]
    }
    
    /// Returns the text color of field or prompt given current state.
    func textColor<TextColors: FieldTextColor>(
        of keyPath: KeyPath<Config.Appearance.Colors.TextColors.Customized, TextColors>
    ) -> Color {
        let textColors = config.appearance.colors.textColors
        let colors = textColors.customized[keyPath: keyPath]
        let customized = isFocused ? colors.focused : colors.notFocused
        if isEmpty {
            return customized.neutral ?? textColors.defaultColors.neutral
        } else if isValid {
            return customized.valid ?? textColors.defaultColors.valid
        } else {
            assert(!isValid && !isEmpty)
            return customized.invalid  ?? textColors.defaultColors.invalid
        }
    }
    
    /// An empty array means that `text` **is valid**. Else it contains a list
    /// of error messages
    func validationResult() -> [String] {
        let errorMessages: [String] = config.behaviour.validation.rules.compactMap { rule in
            rule.validate(text: text)
        }
      
        return errorMessages
    }
    
    /// Updates validation state by performing validation
    func validate() {
        errorMessages = validationResult()
    }
    
    func onlyIfOKChangeValidationStateToOK() {
        let errors = validationResult()
        guard isValid(given: errors) else {
            // Invalid, but don't change state to error.
            return
        }
        // Validation passes, all OK => change state to OK
        errorMessages = []
    }
}

// MARK: - Subviews
// MARK: -
private extension HoverPromptTextField {
    
    func lineColor() -> Color {
        let lineColors = config.appearance.colors.lineColors
        let defaultColors = config.appearance.colors.defaultColors
        if isEmpty {
            return lineColors.neutral ?? defaultColors.neutral
        } else if isValid {
            return lineColors.valid ?? defaultColors.valid
        } else {
            assert(!isValid && !isEmpty)
            return lineColors.invalid ?? defaultColors.invalid
        }
    }
    
    func lineHeight() -> CGFloat {
        let heights = isFocused ? config.appearance.lineHeight.focused : config.appearance.lineHeight.notFocused
        if isEmpty {
            return heights.neutral
        } else if isValid {
            return heights.valid
        } else {
            assert(!isValid && !isEmpty)
            return heights.invalid
        }
    }
    
    @ViewBuilder func line() -> some View {
        lineColor()
            .frame(maxWidth: .infinity, idealHeight: lineHeight()).fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder func maybeError() -> some View {
        // TODO: Animate between them..?
        // TODO: Remove this ugly "hack" to make the wrappedField always have the same Y pos.
        Group {
            if let error = errorMessages.first {
                Text(error)
            } else {
                Text(" ")
            }
        }.font(font(of: \.error))
        .foregroundColor(textColor(of: \.errorLabel))
    }
    
    @ViewBuilder func maybeHoveringPromptAndRequirements() -> some View {
        HStack(alignment: .bottom) {
            maybeHoveringPrompt()
            if shouldDisplay(.inputRequirements) {
                maybeRequirements()
            }
        }
     
    }
    
    @ViewBuilder func maybeRequirements() -> some View {
        if isFocused, !isEmpty, !isValid, let firstRequirment = inputRequirments.first {
            Text(firstRequirment.requirement)
                .font(font(of: \.requirements))
                .foregroundColor(textColor(of: \.requirmentLabel))
        }
    }
    
    @ViewBuilder func maybeHoveringPrompt() -> some View {
        // TODO: Remove this ugly "hack" to make the wrappedField always have the same Y pos.
        Text(isEmpty ? " " : prompt)
            .font(font(of: \.prompt))
            .textSelection(isEmpty ? .disabled : .disabled)
                .foregroundColor(textColor(of: \.hoveringPrompt))
                .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder func wrappedField() -> some View {
        Group {
            if config.isSecure && !isRevealingSecrets {
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
        .onChange(of: isFocused) { _ in
            switch config.behaviour.validationTriggering {
            case .eagerErrorEagerOK:
                validate()
            case .lazyErrorEagerOK:
                if isFocused {
                    onlyIfOKChangeValidationStateToOK()
                } else  {
                    if isEmpty {
                        onlyIfOKChangeValidationStateToOK()
                    } else {
                        validate()
                    }
                }
            }
        }.onChange(of: text) { _ in
            switch config.behaviour.validationTriggering {
            case .lazyErrorEagerOK:
                onlyIfOKChangeValidationStateToOK()
            case .eagerErrorEagerOK:
                 validate()
            }
        }
    }

}
