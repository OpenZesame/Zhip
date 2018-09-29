//
//  PaymentModelTests.swift
//  ZesameTests
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import Zesame_iOS

class PaymentModelTests: XCTestCase {

    private let addressAsDouble: Double = 0xABCDEF0123456789ABCDEF0123456789ABCDEF01p0
    func testCreatingValidPaymentUsingDesignatedInitializer() {
        guard
            let address = try? Address(double: addressAsDouble),
            let amount = try? Amount(double: 1),
            let gas = try? Gas(rawPrice: 1, rawLimit: 1)
            else {
                XCTFail("Should have been possible to create address, amount of gas using valid values")
                return
        }
        let payment = Payment(to: address, amount: amount, gas: gas)
        XCTAssertTrue(payment.recipient.address == addressAsDouble)
        XCTAssertTrue(payment.amount.amount == 1)
        XCTAssertTrue(payment.gas.limit.limit == 1)
        XCTAssertTrue(payment.gas.price.price == 1)
    }

    func testCreatingValidPaymentUsingDesignatedInitializerPassingLiterals() {
        let payment = Payment(to: 0xABCDEF0123456789ABCDEF0123456789ABCDEF01p0, amount: 1, gas: Gas(price: 1, limit: 1))
        XCTAssertTrue(payment.recipient.address == addressAsDouble)
        XCTAssertTrue(payment.amount.amount == 1)
        XCTAssertTrue(payment.gas.limit.limit == 1)
        XCTAssertTrue(payment.gas.price.price == 1)
    }

    func testCreatingValidPaymentUsingConvenienceInitializer() {
        let payment = try? Payment(addressDouble: 0xABCDEF0123456789ABCDEF0123456789ABCDEF01p0, amountDouble: 1, priceDouble: 1, limitDouble: 1)
        XCTAssertTrue(payment?.recipient.address == addressAsDouble)
        XCTAssertTrue(payment?.amount.amount == 1)
        XCTAssertTrue(payment?.gas.limit.limit == 1)
        XCTAssertTrue(payment?.gas.price.price == 1)
    }

    func testCreatingValidPaymentUsingConvenienceInitializerAddressAsString() {
        let payment = try? Payment(addressString: "0xABCDEF0123456789ABCDEF0123456789ABCDEF01", amountDouble: 1, priceDouble: 1, limitDouble: 1)
        XCTAssertTrue(payment?.recipient.address == addressAsDouble)
        XCTAssertTrue(payment?.amount.amount == 1)
        XCTAssertTrue(payment?.gas.limit.limit == 1)
        XCTAssertTrue(payment?.gas.price.price == 1)
    }
}
