//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-12.
//

import XCTest
@testable import PIN

final class PINTests: XCTestCase {
	func testPINCannotBeShort() throws {
		XCTAssertThrowsError(try PIN(digits: [Digit.four])) { error in
			XCTAssertEqual(error as? PIN.Error, PIN.Error.pincodeTooShort)
		}
	}
}
