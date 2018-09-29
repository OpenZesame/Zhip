//
//  Targetable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-10.
//
//

import Foundation

public protocol Targetable: class {
    func addTarget(using actor: Actor)
}

extension UIControl: Targetable {
    public func addTarget(using actor: Actor) {
        addTarget(actor.target, action: actor.selector, for: actor.event)
    }
}
