//
//  FormValidator.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import FormValidatorSwift

extension Validator {
    func validate(text: String?) -> Bool {
        if let cond = checkConditions(text) {
            return cond.isEmpty
        } else {
            return true
        }
    }
}

extension String {
    func validates(by valididator: Validator) -> Bool {
        return valididator.validate(text: self)
    }
}

extension Optional where Wrapped == String {
    func validates(by valididator: Validator) -> Bool {
        return valididator.validate(text: self)
    }
}
