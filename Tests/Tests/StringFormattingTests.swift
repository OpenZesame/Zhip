//
//  StringFormattingTests.swift
//  ZhipTests
//
//  Created by Alexander Cyon on 2018-12-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Zhip
import DateToolsSwift

class StringFormattingTests: XCTestCase {

    func testFormatting() {
        func f(_ s: String) -> String {
            let new = s.inserting(string: "x", every: 3)
            return new
        }

        XCTAssertEqual(f("1"), "1")
        XCTAssertEqual(f("12"), "12")
        XCTAssertEqual(f("123"), "123")
        XCTAssertEqual(f("1234"), "1x234")
        XCTAssertEqual(f("12345"), "12x345")
        XCTAssertEqual(f("123456"), "123x456")
        XCTAssertEqual(f("1234567"), "1x234x567")
        XCTAssertEqual(f("12345678"), "12x345x678")
        XCTAssertEqual(f("123456789"), "123x456x789")
        XCTAssertEqual(f("123456789a"), "1x234x567x89a")
    }

    // These tests might fail if they are run exactly 00:01... kind of funny. Not so probable though.
    func testTimeAgoEnglish() {
        func s(_ date: Date) -> String {
            return date.timeAgoSinceNow
        }
        XCTAssertEqual(
            s(1.seconds.earlier),
            "Just now"
        )

        XCTAssertEqual(
            s(2.seconds.earlier),
            "Just now"
        )

        XCTAssertEqual(
            s(3.seconds.earlier),
            "3 seconds ago"
        )

        XCTAssertEqual(
            s(59.seconds.earlier),
            "59 seconds ago"
        )

        XCTAssertEqual(
            s(1.minutes.earlier),
            "A minute ago"
        )

        XCTAssertEqual(
            s(2.minutes.earlier),
            "2 minutes ago"
        )
    }
}
