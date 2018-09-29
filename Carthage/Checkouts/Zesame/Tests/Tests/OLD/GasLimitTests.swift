//
//  GasLimitTests.swift
//  ZesameTests
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import Zesame_iOS

class GasLimitTests: XCTestCase {

    func testCreatingInvalidGasLimitWithNegativeValue() {
        let limit = try? Gas.Limit(double: -1)
        XCTAssertNil(limit, "Should not be possible to create limit with negative value")
    }

    func testCreatingInvalidGasLimitWithZero() {
        let limit = try? Gas.Limit(double: 0)
        XCTAssertNil(limit, "Should not be possible to create limit with negative value")
    }

    func testCreatingValidGasLimitUsingDesignatedInitializer() {
        let limit = try? Gas.Limit(double: 1)
        XCTAssertTrue(limit?.limit == 1)
    }

    func testCreatingValidGasLimitUsingExpressibleByFloatLiteralInitializer() {
        let limit: Gas.Limit = 1.0
        XCTAssertTrue(limit.limit == 1)
    }

    func testCreatingValidGasLimitUsingExpressibleByIntegerLiteralInitializer() {
        let limit: Gas.Limit = 1
        XCTAssertTrue(limit.limit == 1)
    }
}
