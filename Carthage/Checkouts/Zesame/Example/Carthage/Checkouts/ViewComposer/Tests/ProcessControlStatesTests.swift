//
//  ProcessControlStatesTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-26.
//
//

import Foundation

import XCTest
@testable import ViewComposer
class ProcessControlStatesTests: BaseXCTest {

    func testProcessControlStatedNoImage() {
        let colorNormal: UIColor = .red
        let colorHighlighted: UIColor = .green
        let colorDisabled: UIColor = .gray
        let colorSelected: UIColor = .brown
        let colorFocused: UIColor = .cyan
        let colorApplication: UIColor = .purple
        let colorReserved: UIColor = .orange
        let states: [ControlStateStyle] = [
            Normal(fooText, colorNormal),
            Highlighted(colorHighlighted),
            Disabled(colorDisabled),
            Selected(colorSelected),
            Focused(colorFocused),
            Application(colorApplication),
            Reserved(colorReserved),
        ]
        let button: UIButton = [.states(states)]
        assertIs(button.title(for: .normal), is: fooText)
        assertIs(button.titleColor(for: .normal), is: colorNormal)
        
        assertIs(button.title(for: .highlighted), is: fooText)
        assertIs(button.titleColor(for: .highlighted), is: colorHighlighted)
        
        assertIs(button.title(for: .disabled), is: fooText)
        assertIs(button.titleColor(for: .disabled), is: colorDisabled)
        
        assertIs(button.title(for: .selected), is: fooText)
        assertIs(button.titleColor(for: .selected), is: colorSelected)
        
        assertIs(button.title(for: .focused), is: fooText)
        assertIs(button.titleColor(for: .focused), is: colorFocused)
        
        assertIs(button.title(for: .application), is: fooText)
        assertIs(button.titleColor(for: .application), is: colorApplication)
        
        assertIs(button.title(for: .reserved), is: fooText)
        assertIs(button.titleColor(for: .reserved), is: colorReserved)
    }
    
    func testControlStateInitializerTitleOnly() {
        let controlStateStyle = Normal(fooText)
        assertButton(with: controlStateStyle)
    }
    
    func testControlStateInitializerTitleColorOnly() {
        let controlStateStyle = Normal(.red)
        assertButton(with: controlStateStyle)
    }
    
    func testControlStateInitializerBorderColorOnly() {
        let controlStateStyle = Normal(borderColor: .red)
        assertButton(with: controlStateStyle)
    }
    
    func testControlStateInitializerTitleAndTitleColor() {
        let controlStateStyle = Normal(fooText, .red)
        assertButton(with: controlStateStyle)
    }

    func testControlStateInitializerTitleAndTitleColorAndBorderColor() {
        let controlStateStyle = Normal(fooText, titleColor: .red, borderColor: .blue)
        assertButton(with: controlStateStyle)
    }
    
    func testControlStateInitializerTitleAndImage() {
        let controlStateStyle = Normal(fooText, image)
        assertButton(with: controlStateStyle)
    }

    func testControlStateInitializerTitleAndTitleColorAndImage() {
        let controlStateStyle = Normal(fooText, image, .red)
        assertButton(with: controlStateStyle)
    }
    
    func testControlStateInitializerTitleAndTitleColorAndImageAndBorderColor() {
        let controlStateStyle = Normal(fooText, image: image, titleColor: .red, borderColor: .blue)
        assertButton(with: controlStateStyle)
    }
    
    private func assertButton(with style: ControlStateStyle) {
        let button: UIButton = [.states([style])]
        let state = style.state
        if let title = style.title {
            assertIs(button.title(for: state), is: title)
        }
        if let titleColor = style.titleColor {
            assertIs(button.titleColor(for: state), is: titleColor)
        }
        if let image = style.image {
            assertIs(button.image(for: state), is: image)
        }
        if let borderColor = style.borderColor, state == .normal {
            assertIs(button.layer.borderColor, is: borderColor.cgColor)
        }
    }
}
