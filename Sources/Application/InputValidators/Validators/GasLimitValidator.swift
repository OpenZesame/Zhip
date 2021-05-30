//
//  GasLimitValidator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2021-05-30.
//  Copyright © 2021 Open Zesame. All rights reserved.
//

import Zesame

import Validator


struct GasLimitValidator: InputValidator {

    typealias Error = AmountError<Qa>

    func validate(input limitString: String) -> Validation<GasLimit, Error> {
        guard let gasLimit: GasLimit = .init(limitString) else {
            return self.error(Error.nonNumericString)
        }
        
        guard gasLimit >= GasLimit.minimum else {
            return self.error(Error.tooSmall(min: GasLimit.minimum.description, unit: .qa, showUnit: false))
        }

        return .valid(gasLimit)
    }
}

