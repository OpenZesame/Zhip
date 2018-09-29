//
//  Styleable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public protocol Styleable: ExpressibleByArrayLiteral {
    associatedtype StyleType: Attributed
    associatedtype Element = StyleType.Attribute
    func setup(with style: StyleType)
}

public extension Styleable {
    func setup(with style: StyleType) {
        style.install(on: self)
    }
}
