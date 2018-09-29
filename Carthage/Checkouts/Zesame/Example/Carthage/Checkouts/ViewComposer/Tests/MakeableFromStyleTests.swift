//
//  MakeableFromStyleTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-05.
//
//

import XCTest
@testable import ViewComposer

class MakeableFromStyleTests: XCTestCase {
    
    private let style: ViewStyle = [.text(fooText), .color(color)]
    func testMakingLabelFromMergeBetweenStyleAndSingleAttribute() {
        let label: UILabel = style <<- .text(barText)
        assertIs(label.text, is: barText)
        assertIs(label.backgroundColor, is: color)
    }
    
    func testMakingLabelFromMergeBetweenStyleAndAttributeArray() {
        let label: UILabel = style <<- [.text(barText), .textAlignment(.center)]
        assertIs(label.text, is: barText)
        assertIs(label.backgroundColor, is: color)
        assertIs(label.textAlignment, is: .center)
    }
    
    func testMakingLabelFromMergeBetweenSingleAttributeAndStyle() {
        let label: UILabel = .text(barText) <- style
        assertIs(label.text, is: barText)
        assertIs(label.backgroundColor, is: color)
    }
    
    func testMakingLabelFromMergeBetweenAttributeArrayAndStyle() {
        let label: UILabel =  [.text(barText), .textAlignment(.center)] <- style
        assertIs(label.text, is: barText)
        assertIs(label.backgroundColor, is: color)
        assertIs(label.textAlignment, is: .center)
    }
    
    func testMakingButtonFromMergeBetweenStyleAndAttributesArrayOperators() {
        let button: UIButton = style <<- [.text(barText), .textColor(.red)]
        assertIs(button.title(for: .normal), is: barText)
        assertIs(button.backgroundColor, is: color)
        assertIs(button.titleColor(for: .normal), is: .red)
    }
    
}
