//
//  HoverPromptTextField+Config.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-15.
//

import SwiftUI

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
    
}

