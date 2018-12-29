//
//  GasPriceValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-15.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

struct GasPriceValidator: InputValidator {
    typealias Error = AmountValidator.Error

    func validate(input li: String) -> InputValidationResult<GasPrice, Error> {
        let gasPrice: GasPrice
        do {
            gasPrice = try GasPrice(li: li)
        } catch let amountError as AmountError {
            return self.error(amountError)
        } catch {
            incorrectImplementation("AmountValidator.Error should cover all errors")
        }
        return .valid(gasPrice)
    }
}
