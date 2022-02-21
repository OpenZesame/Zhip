//
//  HoverPromptTextField+Behaviour.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import Foundation

public extension HoverPromptTextFieldConfig {
    struct Behaviour {
        public let validationTriggering: ValidationTriggering
        public fileprivate(set) var validation: Validation
        
        /// Possible restriction on the type of characters you can input, either
        /// only some whitelisted characters, or preventing certain blacklistend
        /// characters.
        public let characterRestriction: CharacterRestriction?
        
        public init(
            validationTriggering: ValidationTriggering = .default,
            validation: Validation = .default,
            characterRestriction: CharacterRestriction? = nil
        ) {
            self.validationTriggering = validationTriggering
            self.validation = validation
            self.characterRestriction = characterRestriction
        }
    }
}


public enum CharacterRestriction: BasicValidation, Equatable {
    case doesNotContain(blacklisted: CharacterSet)
    case onlyContains(whitelisted: CharacterSet)
    
    public func isValid(given text: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: text)
        switch self {
        case .doesNotContain(let blacklistedCharacters):
            return characterSet.intersection(blacklistedCharacters).isEmpty
        case .onlyContains(let whitelistedCharacters):
            return whitelistedCharacters.isSuperset(of: characterSet)
        }
    }
}

public extension HoverPromptTextFieldConfig.Behaviour {
    
 
    
    struct Validation {
        
        public fileprivate(set) var rules: [ValidationRule]
        public init(rules: [ValidationRule] = []) {
            self.rules = rules
        }
        
        
        public static let noRules = Self(rules: [])
        public static let `default` = Self.noRules
    }
    
    enum ValidationTriggering: Equatable {
        public static let `default` = Self.lazyErrorEagerOK
        
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

public protocol BasicValidation {
    func isValid(given text: String) -> Bool
}

public protocol DisplayableInputRequirement {
    var requirement: String { get }
}

public protocol ValidationRule: BasicValidation {
    typealias ErrorMessage = String
    
    /// A validation function: valdiates current text and returns an error
    /// message if the text is invalid. Returning `nil` indicates that the
    /// input **is valid**.
    func validate(text: String) -> ErrorMessage?
}
public extension ValidationRule {
    func isValid(given text: String) -> Bool {
        validate(text: text) == nil
    }
}

public struct Validation: ValidationRule {

    private let _validate: Validate
    
    public init(validate: @escaping Validate) {
        self._validate = validate
    }
    
}

public extension Validation {
    typealias CurrentText = String
    
    /// A validation function: valdiates current text and returns an error
    /// message if the text is invalid. Returning `nil` indicates that the
    /// input **is valid**.
    typealias Validate = (_ currentText: CurrentText) -> ErrorMessage?
    
    
    func validate(text: String) -> ErrorMessage? {
        _validate(text)
    }
}
    
public struct ValidateInputRequirement: ValidationRule, DisplayableInputRequirement {
    public let inputRequirement: InputRequirement
    
    public typealias FormatRequirement = (InputRequirement) -> String
    public let requirement: String

    public typealias FormatError = (InputRequirement, String) -> ValidationRule.ErrorMessage
    private let formatError: FormatError
    
    public init(
        inputRequirement: InputRequirement,
        formatRequirement: FormatRequirement,
        formatError: @escaping FormatError
    ) {
        self.inputRequirement = inputRequirement
        self.requirement = formatRequirement(inputRequirement)
        self.formatError = formatError
    }
    
    public func validate(text: String) -> ErrorMessage? {
        if inputRequirement.isValid(given: text) {
            return nil
        }
        return formatError(inputRequirement, text)
    }
}

public enum InputRequirement: BasicValidation, Equatable {
    public enum Length: BasicValidation, Equatable {
        public enum Variable: BasicValidation, Equatable {
            case minNoMax(Int)
            case maxNoMin(Int)
            case range(min: Int, max: Int)
            public func isValid(given text: String) -> Bool {
                switch self {
                case .maxNoMin(let max):
                    return text.count <= max
                case .minNoMax(let min):
                    return text.count >= min
                case .range(let min, let max):
                    return text.count >= min && text.count <= max
                }
            }
        }
        case variable(Variable)
        case exact(Int)
        
        public func isValid(given text: String) -> Bool {
            switch self {
            case .variable(let variableLength):
                return variableLength.isValid(given: text)
            case .exact(let exactLength):
                return text.count == exactLength
            }
        }
    }
    case length(Length)

    public func isValid(given text: String) -> Bool {
        switch self {
        case .length(let lengthRequirement):
            return lengthRequirement.isValid(given: text)
        }
    }
}
