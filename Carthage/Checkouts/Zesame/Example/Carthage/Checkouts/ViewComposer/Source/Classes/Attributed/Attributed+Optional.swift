//
//  Attributed+Optional.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Optional where Wrapped: Attributed {
    func merge(slave: Wrapped) -> Wrapped {
        guard let `self` = self else { return slave }
        return self.merge(slave: slave)
    }
    
    func merge(master: Wrapped) -> Wrapped {
        guard let `self` = self else { return master }
        return self.merge(master: master)
    }
}
