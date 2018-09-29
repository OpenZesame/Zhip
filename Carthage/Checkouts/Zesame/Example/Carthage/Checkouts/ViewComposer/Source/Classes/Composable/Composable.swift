//
//  Composable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

/// Type that can be instantiated using a `StyleType`. This is neat if you want to create your own styleable type.
public protocol Composable: Styleable {
    init(_ style: StyleType?)
    
    /// This method is called after the `Composable` itself has been created using `init(StyleType)`. Here you can setup subviews using the same `style` that was used to instantiate the `Composable`.
    ///
    /// This method is "optional", since there is a default implementation of it in an extension of the `Composable` protocol.
    ///
    /// - Parameter style: the `StyleType` associated with the Composable containing all the attributes that where used to create the `Composable` itself.
    func setupSubviews(with style: StyleType)
}

extension Composable {
    /* Making the method "optional" */
    public func setupSubviews(with style: StyleType) {}
}

postfix operator ^

/// This is a bit "hacky", this enables us to write `let sv: StackView = [.color(.red)]^`
/// notice the use of the caret symbol. This code would not compile otherwise since the composable
// class `StackView` inherits from the superclass `UIStackView` which already is made `Makeable` by
// this framework. Since `StackView`s superclass `UIStackView` is `Makeable` it is ExpressibleByArrayLiteral
// but Swift is unable to instantiate the subclass. But using the caret operator we can express that 
// we want an instance of the composable sublcass `StackView`.
public postfix func ^<C: Composable>(attributes: [C.StyleType.Attribute]) -> C {
    let style = C.StyleType(attributes)
    return C(style)
}
