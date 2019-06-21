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
    
    private func doTest(_ amountString: String, expected: Double) {
        
        func doubleFromAnyLocale(numberString: String) -> Double? {
            func tryLocale(locale: Locale) -> Double? {
                let formatter = NumberFormatter()
                formatter.locale = locale
                return formatter.number(from: amountString)?.doubleValue
            }
            
            for localeIdentifier in Locale.availableIdentifiers {
                let locale = Locale(identifier: localeIdentifier)
                if let double = tryLocale(locale: locale) {
                    print("Successfully created number from locale with id: \(localeIdentifier)")
                    return double
                } else {
                    print("Failed to create number from locale with id: \(localeIdentifier)")
                }
            }
            return nil
        }
        guard let number = doubleFromAnyLocale(numberString: amountString) else {
            return XCTFail("failed to get number from: `\(amountString)`")
        }
        XCTAssertEqual(number, expected)
    }
  
    func testFo() {
        doTest("0,1", expected: 0.1)
        doTest("0.1", expected: 0.1)
    }
    
    func testZilAmountFromDecimalStringWithDot() {
        XCTAssertNotNil(Double("0.01"))
//        XCTAssertNoThrow(try ZilAmount.init(zil: "0.01"))
    }
    
    func testZilAmountFromDecimalStringWithComma() {
        XCTAssertNotNil(Double("0,01"))
//        XCTAssertNoThrow(try ZilAmount.init(zil: "0,01"))
    }
    
    
    func testCurrntLocaleIsSweden() {
        XCTAssertEqual(Locale.current.identifier, "en_US")
    }
    
    func testAmountFromStringLocale() {
        XCTAssertEqual(Locale.current.identifier, "en_US")
        XCTAssertNotNil(Locale(identifier: "sv_SE"))
        
//        let languages = ["bs", "zh-Hant", "en", "fi", "ko", "lv", "ms", "pl", "pt-BR", "ru", "sr-Latn", "sk", "es", "tr"]
//        UserDefaults.standard.set([languages[0]], forKey: "AppleLanguages")
        
        func assertLanguages(equal: [String]) {
            if let anyLang = UserDefaults.standard.value(forKey: .languagesKey) {
                if let languages = anyLang as? [String] {
                    XCTAssertEqual(languages.count, equal.count)
                    XCTAssertEqual(languages, equal)
                    
                } else {
                    XCTFail("not a string array")
                }
            } else {
                XCTFail("nu value for key `AppleLanguages`")
            }
        }
        
        assertLanguages(equal: ["en-SE"])
//        UserDefaults.standard.set(["en-SE"], forKey: .languagesKey)
//        assertLanguages(equal: ["sv-SE"])
//        XCTAssertEqual(Locale.current.identifier, "sv-SE")
        
//        let swedish = Locale(identifier: "sv_SE")
//        Locale.current = swedish
        
//        try Amount(zil: amountString)
    }
}

private extension String {
    static let languagesKey = "AppleLanguages"
}
