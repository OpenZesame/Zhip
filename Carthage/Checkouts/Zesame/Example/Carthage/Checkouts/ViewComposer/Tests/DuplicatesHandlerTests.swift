//
//  DuplicatesHandlerTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import Foundation

import XCTest
@testable import ViewComposer
class DuplicatesHandlerTests: BaseXCTest {
    func testCustomAttributeDuplicatesInstantiation() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        let bar = 237
        let style: ViewStyle = [.foo(fooText), .bar(bar)]
        guard let foobarViewStyle: FooBarViewStyle = style.value(.custom) else { XCTAssert(false); return }
        XCTAssert(foobarViewStyle.count == 2)
        XCTAssert(foobarViewStyle.value(.bar) == bar)
        XCTAssert(foobarViewStyle.value(.foo) == fooText)
    }
    
    func testMakeableDuplicatesHandlerAlongSideStandardAttributes() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        let bar = 237
        let field: UITextField = [.foo(fooText), .bar(bar), .color(.red), .cornerRadius(cornerRadius)]
        assertIs(field.placeholder, is: fooText)
        assertIs(field.text, is: "\(bar)")
        assertIs(field.backgroundColor, is: .red)
        assertIs(field.layer.cornerRadius, is: cornerRadius)
        
    }
}

struct FoobarViewAttributeDuplicatesHandler: DuplicatesHandler {
    typealias AttributesExpressible = ViewStyle
    func choseDuplicate(from duplicates: [ViewAttribute]) -> ViewAttribute {
        var foobarAttributes: [FooBarViewAttribute] = []
        for duplicate in duplicates {
            switch duplicate {
            case .custom(let custom):
                guard let foobarStyle = custom as? FooBarViewStyle else { continue }
                foobarAttributes.append(contentsOf: foobarStyle.attributes)
            default:
                continue
            }
        }
        return ViewAttribute.custom(FooBarViewStyle(foobarAttributes))
    }
}
