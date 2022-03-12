//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-12.
//

import XCTest
@testable import PINCode

final class PINCodeTests: XCTestCase {
	func testPINCodeCannotBeShort() throws {
		XCTAssertThrowsError(try Pincode(digits: [Digit.four])) { error in
			XCTAssertEqual(error as? Pincode.Error, Pincode.Error.pincodeTooShort)
		}
	}
}
