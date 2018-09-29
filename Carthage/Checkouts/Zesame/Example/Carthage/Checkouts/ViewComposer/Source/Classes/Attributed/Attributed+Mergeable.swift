//
//  Attributed+Mergeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Attributed {
    
    func merge(slave: Self, intercept: Bool) -> Self {
        var intercepted = self
        if intercept {
            Self.mergeInterceptors.forEach { intercepted = $0.interceptMerge(master: intercepted, slave: slave) }
        }
        let unionSet = Set(intercepted.stripped).union(Set(slave.stripped))
        let unionAttributes = (intercepted.attributes + slave.attributes).filter(stripped: Array(unionSet))
        return Self(unionAttributes)
    }
    
    func merge(slave: [Attribute], intercept: Bool) -> Self {
        return merge(slave: Self(slave), intercept: intercept)
    }
    
    func merge(master: [Attribute], intercept: Bool) -> Self {
        return Self(master).merge(slave: self, intercept: intercept)
    }
    
    func merge(slave: Attribute, intercept: Bool) -> Self {
        return merge(slave: Self([slave]), intercept: intercept)
    }
    
    func merge(master: Self, intercept: Bool) -> Self {
        return master.merge(slave: self, intercept: intercept)
    }
    
    func merge(master: Attribute, intercept: Bool) -> Self {
        return Self([master]).merge(slave: self, intercept: intercept)
    }
}

public extension Attributed {
    func merge(slave: Self) -> Self {
        return merge(slave: slave, intercept: true)
    }
    
    func merge(slave: [Attribute]) -> Self {
        return merge(slave: slave, intercept: true)
    }
    
    func merge(master: [Attribute]) -> Self {
        return merge(master: master, intercept: true)
    }
    
    func merge(slave: Attribute) -> Self {
        return merge(slave: slave, intercept: true)
    }
    
    func merge(master: Self) -> Self {
        return merge(master: master, intercept: true)
    }
    
    func merge(master: Attribute) -> Self {
        return merge(master: master, intercept: true)
    }
}
