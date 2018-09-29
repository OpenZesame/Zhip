//
//  AmountModelTests.swift
//  ZesameTests
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//


import XCTest
@testable import Zesame_iOS

class AmountModelTests: XCTestCase {

    func testCreatingValidAmountUsingDesignatedInitializer() {
        let amount = try? Amount(double: 1)
        XCTAssertTrue(amount?.amount == 1)
    }

    func testCreatingValidAmountUsingExpressibleByFloatLiteralInitializer() {
        let amount: Amount = 1.0
        XCTAssertTrue(amount.amount == 1)
    }

    func testCreatingValidAmountUsingExpressibleByIntegerLiteralInitializer() {
        let amount: Amount = 1
        XCTAssertTrue(amount.amount == 1)
    }
}
