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
import XCTest
import Zesame
import UIKit
@testable import Zhip

class CharacterSetTests: XCTestCase {

    func testDecimalsWithSeparator() {
        let characterSet = CharacterSet.decimalWithSeparator
        var charsAsStrings = [Int](0...9).map { "\($0)" }
        charsAsStrings.append(Locale.current.decimalSeparatorForSure)
        func doTest(expected: Bool) {
            let booleanAnd = charsAsStrings
                .map { CharacterSet(charactersIn: $0).isSubset(of: characterSet) }
                .reduce(true) { $0 && $1 }
            XCTAssertEqual(booleanAnd, expected)
        }
        doTest(expected: true)
        charsAsStrings.append("a")
        doTest(expected: false)
        
    }
    
    func testZilAmountFromDecimalStringWithComma() {
        XCTAssertNotNil(Double("0\(decSep)01"))
    }
    
}

private extension String {
    static let languagesKey = "AppleLanguages"
}

private let decSep = Locale.current.decimalSeparatorForSure
