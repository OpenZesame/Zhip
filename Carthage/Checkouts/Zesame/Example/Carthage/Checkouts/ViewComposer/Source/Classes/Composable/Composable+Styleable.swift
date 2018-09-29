//
//  Composable+Styleable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

/// Makes it possible to instantiate and style `Composable` from array literal like this: `let myComposableView: MyComposableView = [.text("foo")]`
public extension Styleable where Self: Composable, Self.StyleType.Attribute == Element {
    init(arrayLiteral elements: Self.Element...) {
        self.init(StyleType(Self.StyleType.removeDuplicatesIfNeededAndAble(elements)))
    }
}
