//
//  StrippedEquatableComparableTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import XCTest
@testable import ViewComposer

class StrippedEquatableComparableTests: XCTestCase {
    func testFoobarAttributeStrippedEquatable() {
        XCTAssert(FooBarViewAttribute.bar(0).stripped == FooBarViewAttributeStripped.bar)
        XCTAssert(FooBarViewAttribute.bar(0).stripped == FooBarViewAttribute.bar(1).stripped)
        XCTAssert(FooBarViewAttribute.foo("foo").stripped == FooBarViewAttributeStripped.foo)
        XCTAssert(FooBarViewAttribute.foo("foo").stripped == FooBarViewAttribute.foo("bar").stripped)
    }
    
    func testFoobarAttributeStrippedEquatableInequality() {
        XCTAssert(FooBarViewAttribute.foo("foo").stripped != FooBarViewAttribute.bar(1).stripped)
        XCTAssertFalse(FooBarViewAttribute.foo("foo").stripped != FooBarViewAttributeStripped.foo)
        XCTAssert(FooBarViewAttribute.foo("foo").stripped != FooBarViewAttributeStripped.bar)
        XCTAssertFalse(FooBarViewAttribute.foo("foo").stripped != FooBarViewAttributeStripped.foo)
    }
    
    func testFoobarAttributeInStyleStrippedEquatable() {
        let fooStyle: ViewStyle = [.foo(fooText)]
        let barStyle: ViewStyle = [.bar(0)]
        XCTAssert(fooStyle.attributes.first!.stripped == ViewAttributeStripped.custom)
        XCTAssert(barStyle.attributes.first!.stripped == ViewAttributeStripped.custom)
        XCTAssert(fooStyle.attributes.first!.stripped == barStyle.attributes.first!.stripped)
    }
    
    func testFoobarAttributeStrippedComparable() {
        XCTAssert(FooBarViewAttribute.foo("foo").stripped > FooBarViewAttribute.bar(1).stripped)
        XCTAssert(FooBarViewAttribute.foo("foo").stripped > FooBarViewAttributeStripped.bar)
        XCTAssert(FooBarViewAttribute.bar(1).stripped < FooBarViewAttribute.foo("foo").stripped)
        XCTAssert(FooBarViewAttributeStripped.bar < FooBarViewAttribute.foo("foo").stripped)
        
        XCTAssert(FooBarViewAttribute.foo("foo").stripped >= FooBarViewAttribute.bar(1).stripped)
        XCTAssert(FooBarViewAttribute.foo("foo").stripped >= FooBarViewAttributeStripped.bar)
        XCTAssert(FooBarViewAttribute.bar(1).stripped <= FooBarViewAttribute.foo("foo").stripped)
        XCTAssert(FooBarViewAttributeStripped.bar <= FooBarViewAttribute.foo("foo").stripped)
    }
}
