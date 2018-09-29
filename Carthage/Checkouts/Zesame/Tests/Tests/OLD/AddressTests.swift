//
//  AddressTests.swift
//  ZesameTests
//
//  Created by Alexander Cyon on 2018-05-24.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import Zesame_iOS

class AddressTests: XCTestCase {

    private let addressAsDouble: Double = 0xABCDEF0123456789ABCDEF0123456789ABCDEF01p0
    private let addressAsDoubleMax: Double = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFp0

    func testCreatingInvalidAddressUsingStringNotStartingWith0x() {
        let invalidAddress = try? Address(string: "ABCDEF0123456789ABCDEF0123456789ABCDEF01")
        XCTAssertNil(invalidAddress, "Address should be nil, it should not be possible to instantiate addresses without starting with 0x using the designated initializer")
    }

    func testCreatingValidAddressUsingDesignatedInitializer() {
        let address = try? Address(double: addressAsDouble)
        XCTAssertTrue(addressAsDouble == address?.address)
    }

    func testCreatingValidAddressUsingDesignatedInitializerMaxValue() {
        let address = try? Address(double: addressAsDoubleMax)
        XCTAssertTrue(addressAsDoubleMax == address?.address)
    }

    func testCreatingValidAddressUsingExpressibleByFloatLiteral() {
        // Using `ExpressibleByStringLiteral` will result in fatalError if passing an invalid address
        let address: Address = 0xABCDEF0123456789ABCDEF0123456789ABCDEF01p0
        XCTAssertTrue(addressAsDouble == address.address)
    }

    func testCreatingValidAddressUsingExpressibleByStringLiteral() {
        // Using `ExpressibleByStringLiteral` will result in fatalError if passing an invalid address
        let address: Address = "0xABCDEF0123456789ABCDEF0123456789ABCDEF01"
        XCTAssertTrue(addressAsDouble == address.address)
    }

    func testCreatingValidAddressUsingString() {
        // Using `ExpressibleByStringLiteral` will result in fatalError if passing an invalid address
        let address = try? Address(string: "0xABCDEF0123456789ABCDEF0123456789ABCDEF01")
        XCTAssertTrue(addressAsDouble == address?.address)
    }
}
