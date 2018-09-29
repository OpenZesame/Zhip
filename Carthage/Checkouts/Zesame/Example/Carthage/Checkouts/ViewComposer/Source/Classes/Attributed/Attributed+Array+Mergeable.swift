//
//  Attributed+Array+Mergeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Array where Element: AssociatedValueStrippable {
    func filter(stripped: [Element.Stripped]) -> [Element] {
        var filtered = [Element]()
        for attribute in self {
            guard stripped.contains(attribute.stripped) && !(filtered.map { $0.stripped }.contains(attribute.stripped)) else { continue }
            filtered.append(attribute)
        }
        return filtered
    }
    
    func merge<A: Attributed>(slave: A) -> A where A.Attribute == Element {
        return A(self).merge(slave: slave)
    }
    
    func merge<A: Attributed>(master: A) -> A where A.Attribute == Element {
        return A(self).merge(master: master)
    }
}
