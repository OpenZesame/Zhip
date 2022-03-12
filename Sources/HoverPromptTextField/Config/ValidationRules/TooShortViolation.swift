//
//  TooShortViolation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import Foundation

//public extension HoverPromptTextFieldConfig.Behaviour.Validation.Rule {
//    struct TooShortViolation: Equatable {
//        public let minimumLength: Int
//        public let actualLength: Int
//        
//        /// The number of too few characters the text have.
//        public var dearthCharacterCount: Int {
//            minimumLength - actualLength
//        }
//        
//        internal init(minimumLength: Int, actualLength: Int) {
//            precondition(actualLength < minimumLength)
//            self.minimumLength = minimumLength
//            self.actualLength = actualLength
//        }
//    }
//}
//
//public extension HoverPromptTextFieldConfig.Behaviour.Validation.Rule {
//    static func minimumLength(
//        of minimumLength: Int,
//        _ errorMessage: @escaping (TooShortViolation) -> String
//    ) -> Self {
//        Self { text in
//            guard text.count >= minimumLength else {
//                return errorMessage(
//                    TooShortViolation(
//                        minimumLength: minimumLength,
//                        actualLength: text.count
//                    )
//                )
//            }
//            return nil // valid
//        }
//    }
//    
//    static func minimumLength(
//        of minimumLength: Int
//    ) -> Self {
//        Self.minimumLength(of: minimumLength) { tooShortViolation in
//            "\(tooShortViolation.dearthCharacterCount) too few."
//        }
//    }
//}
