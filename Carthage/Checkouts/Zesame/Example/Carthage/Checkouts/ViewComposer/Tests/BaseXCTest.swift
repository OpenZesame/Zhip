//
//  BaseXCTest.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation
import XCTest
@testable import ViewComposer

let text: String = "foobar"
let fooText: String = "foo"
let barText: String = "bar"
let bazText: String = "baz"
let isHidden = true
let color: UIColor = .red
let cornerRadius: CGFloat = 3.1415
let fooRadius: CGFloat = 42
let barRadius: CGFloat = 237
let spacing: CGFloat = 42
var image: UIImage { return UIImage() }
var arrangedSubviews: [UIView] { return [UILabel(), UIView(), UIButton()] }

func assertIs<Value: Equatable>(_ optional: Value?, `is` expected: Value) {
    guard let actual = optional else {
        XCTFail("Value should not be nil")
        return
    }
    XCTAssert(actual == expected, "Expected '\(expected)', was: '\(actual)'")
}


class BaseXCTest: XCTestCase {
    
    override func setUp() {
        ViewStyle.mergeInterceptors = []
        ViewStyle.duplicatesHandler = nil
    }
}
