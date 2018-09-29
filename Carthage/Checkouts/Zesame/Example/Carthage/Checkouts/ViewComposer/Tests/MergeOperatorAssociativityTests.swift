//
//  MergeOperatorAssociativityTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-14.
//
//

import XCTest
@testable import ViewComposer

func assertStyle(_ style: ViewStyle, containsText expected: String, _ message: String? = nil) {
    guard let actual: String = style.value(.text) else {
        XCTFail("StyleType does not contain `text` attribute")
        return
    }
    let message = message ?? "Expected '\(expected)', was: '\(actual)'"
    XCTAssert(actual == expected, message)
}


class MergeOperatorAssociativityTests: XCTestCase {
    
  
    func testAssociativityWhenItDoesNotMatter() {
        let foo: ViewStyle = [.text(fooText)]
        let bar: ViewStyle = [.text(barText)]
        
        assertStyle(foo <<- bar <<- .text(bazText), containsText: bazText)
        assertStyle(foo <- bar <- .text(bazText), containsText: fooText)
        assertStyle(foo <<- bar <- .text(barText), containsText: barText)
    }
    
    func testAssociativityVerifyThatRightAssociativtyIsUsed() {
        let foo: ViewStyle = [.text(fooText)]
        let bar: ViewStyle = [.text(barText)]
        
        // ViewComposer uses `Right` associativity
        assertStyle(foo <- bar <<- .text(bazText), containsText: fooText)
        XCTAssertFalse((foo <- bar <<- .text(bazText)).value(.text) == bazText, "Should not also be true, should contain `foo`")
    }
}
