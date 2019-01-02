//
//  ZhipTests.swift
//  ZhipTests
//
//  Created by Alexander Cyon on 2018-05-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import XCTest
@testable import Zhip

enum EnumWithAssociatedValue {
    case foo(Int)
}

enum EnumRawRepresentedByString: String {
    case buz
    case baz = "BaZ"
}

class AutoEnumCaseNameTests: XCTestCase {

    func testNameOfCaseInEnum() {
        XCTAssertEqual(nameOf(enumCase: EnumWithAssociatedValue.foo(123)), "foo")
        XCTAssertEqual(nameOf(enumCase: EnumRawRepresentedByString.buz), EnumRawRepresentedByString.buz.rawValue)
        XCTAssertEqual(nameOf(enumCase: EnumRawRepresentedByString.baz), "baz")
    }
}
