//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-12.
//

import XCTest
@testable import PINCode

final class PINCodeTests: XCTestCase {
	func testPINCode() throws {
		let pin = try Pincode(digits: [Digit.four])
		XCTAssertNotNil(pin)
	}
}
