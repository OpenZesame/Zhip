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
    public let config: Config

    /// A prompt of what is being asked for, that will move up above the
    /// textfield when inputted text is non empty.
    let prompt: String
    
    @FocusState private var isFocused: Bool

    /// The error messages produces by running the validation rules against
    /// the `text`. An empty array means `text` is **valid**.
    @State private var errorMessages = [String]()
   
    init(
        prompt: String,
        text: Binding<String>,
        config: Config = .default
    ) {
        self.prompt = prompt
        self._text = text
        self.config = config
    }
}

// MARK: - Public
// MARK: -
public extension HoverPromptTextField {
    /// If the `text` equals the empty string.
    var isEmpty: Bool {
        text.isEmpty
    }
    
    
    /// If the `text` validates against the validation rules. Will always be
    /// true, i.e. valid, if the valdiation rule set provided was empty.
    var isValid: Bool {
        isValid(given: errorMessages)
    }
}

// MARK: - Convenience init
// MARK: -
public extension HoverPromptTextField {
    init(
        prompt: String,
        text: Binding<String>,
        defaultColors: DefaultColors,
        isSecure: Bool = false
    ) {
        self.init(
            prompt: prompt,
            text: text,
            config: .init(
                isSecure: isSecure,
                appearance: .init(
                    colors: .init(
                        textColors: .init(
                            defaultColors: defaultColors,
                            customizedColors: .default
                        )
                    )
                ),
                behaviour: .default
            )
        )
    }
}

// MARK: - View
// MARK: -
public extension HoverPromptTextField {
    var body: some View {
        VStack(alignment: .leading) {
            maybeHoveringPrompt()
            
            ZStack(alignment: .leading) {
                if isEmpty {
                    Text(prompt).foregroundColor(textColor(of: \.promptWhenEmpty))
                }
                wrappedField()
            }
            
            maybeErrorOrRequirment()
        }
//        .frame(height: 64, alignment: .leading)
    }
}

// MARK: - Private
// MARK: -
private extension HoverPromptTextField {
    
    func isValid(given errors: [String]) -> Bool {
        errors.isEmpty
    }
    
    /// An empty array means no requirements
    var inputRequirments: [ValidateInputRequirement] {
        config.behaviour.validation.rules.compactMap { $0 as? ValidateInputRequirement }
    }
    
    /// Returns the text color of field or prompt given current state.
    func textColor<TextColors: FieldTextColor>(
        of keyPath: KeyPath<Config.Appearance.Colors.TextColors.Customized, TextColors>
    ) -> Color {
        let textColors = config.appearance.colors.textColors
        let colors = textColors.customizedColors[keyPath: keyPath]
        let customized = isFocused ? colors.focused : colors.notFocused
        if isEmpty {
            return customized.neutral ?? textColors.defaultColors.neutral
        } else {
            if isValid {
                return customized.valid ?? textColors.defaultColors.valid
            } else {
                return customized.invalid  ?? textColors.defaultColors.invalid
            }
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
    
    @ViewBuilder func maybeErrorOrRequirment() -> some View {
        // TODO Animate between them..?
        if let error = errorMessages.first {
            Text(error)
                .foregroundColor(textColor(of: \.errorLabel))
        } else if let firstRequirment = inputRequirments.first {
            Text(firstRequirment.requirement)
                .foregroundColor(textColor(of: \.requirmentLabel))
        }
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
        .onChange(of: isFocused) { _ in
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
