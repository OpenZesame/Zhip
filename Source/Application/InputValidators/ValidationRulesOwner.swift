//
//  ValidationRulesOwner.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Validator

protocol ValidationRulesOwner {
    associatedtype InputType: Validatable
    var rules: ValidationRuleSet<InputType> { get }
}
