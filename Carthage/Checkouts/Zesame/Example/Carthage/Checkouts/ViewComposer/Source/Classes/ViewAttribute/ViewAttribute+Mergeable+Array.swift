//
//  ViewAttribute+Mergeable+Array.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-10.
//
//

import Foundation

public extension Array where Element == ViewAttribute {
    func merge(master: [ViewAttribute]) -> ViewStyle {
        return ViewStyle(self).merge(master: master)
    }
    
    func merge(master: ViewAttribute) -> ViewStyle {
        return merge(master: [master])
    }
    
    func merge(slave: [ViewAttribute]) -> ViewStyle {
        return ViewStyle(self).merge(slave: slave)
    }
    
    func merge(slave: ViewAttribute) -> ViewStyle {
        return merge(slave: [slave])
    }
    
}
