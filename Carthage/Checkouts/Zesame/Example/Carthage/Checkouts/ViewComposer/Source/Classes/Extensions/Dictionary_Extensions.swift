//
//  Dictionary_Extensions.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import Foundation

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
}
