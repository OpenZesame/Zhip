//
//  ControlStateMergingTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-08-03.
//
//

//ControlStateMerger.self

import Foundation

import XCTest
@testable import ViewComposer
class ControlStateMergingTests: BaseXCTest {
    
    func testMergeOfTwoArrayContainingSingleNormalStateHavingTitleAndColor() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal(.red)]
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
        assertIs(mergedState.titleColor, is: .red)
    }
    
    func testMergeOfArrayNormalStateHavingTextWithArrayWithNormalStateHavingTitleColorAndImageAndBorderColor() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal(image: image, titleColor: .red, borderColor: .blue)]
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
        assertIs(mergedState.titleColor, is: .red)
        XCTAssertNotNil(mergedState.image)
        assertIs(mergedState.borderColor, is: .blue)
    }
    
    func testMergeViewStyleContainingStatesOfArrayNormalStateHavingTextWithArrayWithNormalStateHavingTitleColorAndImageAndBorderColor() {
        XCTAssertTrue(ViewStyle.mergeInterceptors.count == 0)
        ViewStyle.mergeInterceptors.append(ControlStateMerger.self)
        XCTAssertTrue(ViewStyle.mergeInterceptors.count == 1)
        let c1: [ControlStateStyle] = [Normal(fooText)]
        let c2: [ControlStateStyle] = [Normal(image: image, titleColor: .red, borderColor: .blue)]
        
        let s1: ViewStyle = [.states(c1)]
        let s2: ViewStyle = [.states(c2)]
        
        let merged = s1.merge(master: s2)
        XCTAssertTrue(merged.count == 1)
        guard let mergedStates: [ControlStateStyle] = merged.value(.states) else { XCTAssertTrue(false); return }
        XCTAssertTrue(mergedStates.count == 1)
        
        let mergedState = mergedStates[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
        assertIs(mergedState.titleColor, is: .red)
        XCTAssertNotNil(mergedState.image)
        assertIs(mergedState.borderColor, is: .blue)
    }
    
    func testMergeOfTwoArrayContainingNormalAndHighlightedStateBothHavingTitleAndColor() {
        let s1: [ControlStateStyle] = [Normal(fooText), Highlighted(.blue)]
        let s2: [ControlStateStyle] = [Highlighted(barText), Normal(.red)]
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 2)
        for state in merged {
            if state.state == .highlighted {
                assertIs(state.title, is: barText)
                assertIs(state.titleColor, is: .blue)
            } else {
                assertIs(state.state, is: .normal)
                assertIs(state.title, is: fooText)
                assertIs(state.titleColor, is: .red)
            }
        }
    }
    
    func testMergeOfArrayContainingSingleNormalStateHavingTitleWithArrayContainingSingleNormalStateEmtpy() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal()]
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
    }
    
    func testMergeOfArrayContainingSingleNormalStateHavungTitleWithArrayContainingSingleNormalStateEmtpyInvertedOrder() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal()]
        let merged = s2.merge(overwrittenBy: s1)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
    }
    
    func testMergeOfTwoArrayContainingSingleNormalStateHavingTitleConflicting() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal(barText)]
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: barText)
    }
    
    func testMergeOfTwoArrayContainingSingleNormalStateHavingTitleConflictingInverted() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2: [ControlStateStyle] = [Normal(barText)]
        let merged = s2.merge(overwrittenBy: s1)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
    }
    
    func testMergeOfArrayContainingSingleNormalStateHavingTitleWithEmptyArray() {
        let s1: [ControlStateStyle] = [Normal(fooText)]
        let s2 = [ControlStateStyle]()
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 1)
        let mergedState = merged[0]
        assertIs(mergedState.state, is: .normal)
        assertIs(mergedState.title, is: fooText)
    }
    
    func testMergeOfTwoEmptyArrays() {
        let s1 = [ControlStateStyle]()
        let s2 = [ControlStateStyle]()
        let merged = s1.merge(overwrittenBy: s2)
        XCTAssertTrue(merged.count == 0)
    }
}
