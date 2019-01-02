//
//  ValidationRuleHexadecimalCharacters.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Validator

public struct ValidationRuleHexadecimalCharacters: ValidationRule {
    public typealias InputType = String
    public var error: Swift.Error
    private let nestedRule: ValidationRuleCondition<InputType>
    public init(error: Swift.Error) {
        nestedRule = ValidationRuleCondition<InputType>(error: error) {
            guard let inputString = $0 else { return false }
            return CharacterSet.hexadecimalDigits.isSuperset(of: CharacterSet(charactersIn: inputString))
        }
        self.error = error
    }

    public func validate(input: InputType?) -> Bool {
        return nestedRule.validate(input: input)
    }
}
