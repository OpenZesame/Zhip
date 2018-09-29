//
//  Attributed+Collection.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Attributed {
    public var endIndex: Int { return count }
    public var count: Int { return attributes.count }
    public var isEmpty: Bool { return attributes.isEmpty }
    
    public subscript (position: Int) -> Self.Attribute { return attributes[position] }
    
    public func index(after index: Int) -> Int {
        guard index < endIndex else { return endIndex }
        return index + 1
    }
    
    public func index(before index: Int) -> Int {
        guard index > startIndex else { return startIndex }
        return index - 1
    }
}
