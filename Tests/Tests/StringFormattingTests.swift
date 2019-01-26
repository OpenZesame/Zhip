// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
