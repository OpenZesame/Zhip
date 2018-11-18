//
//  StackViewStyleMergeTests.swift
//  ZupremeTests
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import XCTest
@testable import Zupreme

class StackViewStyleMergeTests: XCTestCase {

    let defaultMargin = UIStackView.Style.defaultMargin
    let defaultSpacing = UIStackView.Style.defaultSpacing

    func testDefaultValues() {
        let style = UIStackView.Style()
        XCTAssertEqual(style.spacing, defaultSpacing)
        XCTAssertEqual(style.margin, defaultMargin)
    }

    func testOverrideDefault() {
        let style = UIStackView.Style().merge(yieldingTo: UIStackView.Style(spacing: 237))
        XCTAssertEqual(style.spacing, 237)
        XCTAssertEqual(style.margin, defaultMargin)
    }

    func testMerging() {
        let s1 = UIStackView.Style(spacing: 1)
        let s2 = UIStackView.Style(spacing: 2)
        XCTAssertEqual((s1.merged(other: s2, mode: .yieldToOther)).spacing, 2)
        XCTAssertEqual((s1.merged(other: s2, mode: .overrideOther)).spacing, 1)

        XCTAssertEqual(
            (s1.merged(other: s2, mode: .yieldToOther)).spacing,
            (s2.merged(other: s1, mode: .overrideOther)).spacing
        )

        XCTAssertEqual(
            (s1.merged(other: s2, mode: .overrideOther)).spacing,
            (s2.merged(other: s1, mode: .yieldToOther)).spacing
        )
    }
}
