//
//  GasTests.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import Zesame_iOS

class GasTests: XCTestCase {

    func testValidGasUsingDesignatedInitializer() {
        guard
            let price = try? Gas.Price(double: 1),
            let limit = try? Gas.Limit(double: 1)
            else {
                XCTFail("Price and limit should both be non nil")
                return
        }
        let gas = Gas(price: price, limit: limit)
        XCTAssertTrue(gas.limit.limit == 1)
        XCTAssertTrue(gas.price.price == 1)
    }

    func testValidGasUsingConvenienceInitializer() {
        guard let gas = try? Gas(rawPrice: 1, rawLimit: 1) else {
            XCTFail("It should be possible to instantiate Gas using conveniene initializer by passing non negative raw values for price and limit")
            return
        }
        XCTAssertTrue(gas.limit.limit == 1)
        XCTAssertTrue(gas.price.price == 1)
    }
}
