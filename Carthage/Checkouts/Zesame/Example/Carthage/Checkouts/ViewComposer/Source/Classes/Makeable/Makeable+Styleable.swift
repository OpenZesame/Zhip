//
//  Makeable+Styleable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

/// Makes it possible to instantiate and style `Makeable` from array literal like this: `let label: UILabel = [.text("foo")]`
public extension Styleable where Self: Makeable, Self.Styled == Self, Self.StyleType.Attribute == Element {
    init(arrayLiteral elements: Self.Element...) {
        self = Self.make(Self.StyleType.removeDuplicatesIfNeededAndAble(elements))
    }
}
