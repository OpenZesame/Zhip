//
//  ViewAttribute+Mergeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-10.
//
//

import Foundation

extension ViewAttribute {
    func merge(master: ViewStyle) -> ViewStyle {
        return self <<- master
    }
    
    func merge(master: [ViewAttribute]) -> ViewStyle {
        return self <<- master
    }
    
    func merge(master: ViewAttribute) -> ViewStyle {
        return self <<- master
    }
    
    func merge(slave: ViewStyle) -> ViewStyle {
        return self <- slave
    }
    
    func merge(slave: [ViewAttribute]) -> ViewStyle {
        return self <- slave
    }
    
    func merge(slave: ViewAttribute) -> ViewStyle {
        return self <- slave
    }
}

