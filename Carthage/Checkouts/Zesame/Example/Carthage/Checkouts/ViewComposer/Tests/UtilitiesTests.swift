//
//  UtilitiesTests.swift
//  ViewComposerTests
//
//  Created by Alexander Cyon on 2017-06-18.
//

import XCTest
@testable import ViewComposer

class UtilitiesTests: XCTestCase {
    
    func testRemoveNils() {
        let optionalString: String? = nil
        let strings: [String?] = ["Foo", optionalString, "Bar", optionalString, "Baz"]
        XCTAssert(strings.count == 5)
        XCTAssert(strings.removeNils().count == 3)
        let integers: [Int?] = [2, nil, 4, nil, nil, 5]
        XCTAssert(integers.count == 6)
        XCTAssert(integers.removeNils().count == 3)
    }
}
