//
//  GasLimitValidator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2021-05-30.
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//

import Zesame

struct GasLimitValidator: InputValidator {
    typealias Error = AmountError<Qa>

    func validate(input limitString: String) -> Validation<GasLimit, Error> {
        guard let gasLimit: GasLimit = .init(limitString) else {
            return error(Error.nonNumericString)
        }

        guard gasLimit >= GasLimit.minimum else {
            return error(Error.tooSmall(min: GasLimit.minimum.description, unit: .qa, showUnit: false))
        }

        return .valid(gasLimit)
    }
}
