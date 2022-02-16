//
//  HoverPromptTextField+Config.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

public extension HoverPromptTextField {
    
    struct Config {
        
        /// If text is sensitive and should be hidden, like `SecureField` or not.
        public let isSecure: Bool
        
        /// Which subviews to display, e.g. error messages or any input requirements.
        public let display: Display
        
        /// Validation and when it is performed.
        public let behaviour: Behaviour
        
        /// Colors, fonts, dimensions etc.
        public let appearance: Appearance
        
        public init(
            isSecure: Bool = false,
            display: Display = .default,
            behaviour: Behaviour = .default,
            appearance: Appearance = .default
        ) {
            self.display = display
            self.isSecure = isSecure
            self.behaviour = behaviour
            self.appearance = appearance
        }
    }
}

public extension HoverPromptTextField.Config {
    
    static var `default`: Self { .init(
        isSecure: false,
        display: .default,
        behaviour: .default,
        appearance: .default
    ) }
    
}

public extension HoverPromptTextField.Config {
    struct Display: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
}

public extension HoverPromptTextField.Config.Display {
    static let errorMessage         = Self(rawValue: 1 << 0)
    static let inputRequirements    = Self(rawValue: 1 << 1)
}

public extension HoverPromptTextField.Config.Display {
    static let `default`: Self = .all
    static let all: Self = [.errorMessage, .inputRequirements]
}
