//
//  Attributed+AssociatedValueStrippable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Attributed {
    typealias Stripped = Attribute.Stripped
    var stripped: [Stripped] { return attributes.map { $0.stripped } }
}
