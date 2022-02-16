//
//  TooLongViolation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import Foundation

//public extension HoverPromptTextField.Config.Behaviour.Validation.Rule {
//
//    struct TooLongViolation: Equatable {
//        public let maximumLength: Int
//        public let actualLength: Int
//
//        /// The number of too many characters the text have.
//        public var excessCharacterCount: Int {
//            actualLength - maximumLength
//        }
//        public init(maximumLength: Int, actualLength: Int) {
//            precondition(actualLength > maximumLength)
//            self.maximumLength = maximumLength
//            self.actualLength = actualLength
//        }
//    }
//}
//
//public extension HoverPromptTextField.Config.Behaviour.Validation.Rule {
//    static func maximumLength(
//        of maximumLength: Int,
//        _ errorMessage: @escaping (TooLongViolation) -> String
//    ) -> Self {
//        Self { text in
//            guard text.count <= maximumLength else {
//                return errorMessage(
//                    TooLongViolation(
//                        maximumLength: maximumLength,
//                        actualLength: text.count
//                    )
//                )
//            }
//            return nil // valid
//        }
//    }
//
//    static func maximumLength(
//        of maximumLength: Int
//    ) -> Self {
//        Self.maximumLength(of: maximumLength) { tooLongViolation in
//            "\(tooLongViolation.excessCharacterCount) too long."
//        }
//    }
//
//}

public extension ValidationRule where Self == ValidateInputRequirement {
    static func length(_ requiredLength: InputRequirement.Length) -> ValidationRule {
        let formatRequirement: (InputRequirement) -> String = { _ in
            switch requiredLength {
            case .variable(let variable):
                switch variable {
                case .minNoMax(let min):
                    return ">= \(min)"
                case .maxNoMin(let max):
                    return "<= \(max)"
                case .range(let min, let max):
                    return "[\(min)-\(max)]"
                }
            case .exact(let exact):
                return "\(exact)"
            }
        }
        return ValidateInputRequirement(
            inputRequirement: .length(requiredLength),
            formatRequirement: formatRequirement,
            formatError: { req, _ in
                formatRequirement(req)
            }
        )
    }
    
    static func minimumLength(of minimumLength: Int) -> ValidationRule {
        Self.length(.variable(.minNoMax(minimumLength)))
    }
    
    static func maximumLength(of minimumLength: Int) -> ValidationRule {
        Self.length(.variable(.maxNoMin(minimumLength)))
    }
}
