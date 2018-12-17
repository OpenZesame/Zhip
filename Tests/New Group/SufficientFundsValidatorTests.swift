//
//  SufficientFundsValidatorTests.swift
//  ZupremeTests
//
//  Created by Alexander Cyon on 2018-12-15.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import XCTest

@testable import Zupreme
import Zesame

class SufficientFundsValidatorTests: XCTestCase {

    private let validator = SufficientFundsValidator()

    private let oneZilGasPrice = gasPrice(exponent: 12)

    private static func gasPrice(exponent: Double) -> GasPrice {
        let double: Double = pow(10, exponent)
        let int = Int(double)
        return try! GasPrice(number: int)
    }

    func testMinimumGasPrice() {
        let result = validator.validate(input: (amount: 1, GasPrice.minimum, balance: 2))
        XCTAssertTrue(result.isValid)
    }

    func testOneZilInGas() {
        let result = validator.validate(input: (amount: 1, oneZilGasPrice, balance: 2))
        XCTAssertTrue(result.isValid)
    }

    func testSlightlyOverOneZilInGas() {
        let gasPrice: GasPrice = 1000000000001
        let result = validator.validate(input: (amount: 1, gasPrice, balance: 2))
        XCTAssertFalse(result.isValid)
    }
}
