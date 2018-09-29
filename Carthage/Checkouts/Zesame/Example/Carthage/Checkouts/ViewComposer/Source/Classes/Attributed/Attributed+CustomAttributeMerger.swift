//
//  Attributed+CustomAttributeMerger.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public protocol CustomAttributeMerger {
    associatedtype CustomAttribute: Attributed
    associatedtype StyleType: Attributed
    func customMerge(slave: StyleType, into master: StyleType) -> StyleType
}

extension CustomAttributeMerger where Self: Attributed, Self.Attribute == ViewAttribute {
    public func customMerge(slave: ViewStyle, into master: ViewStyle) -> ViewStyle {
        let merged = master.merge(slave: slave)
        if let customStyle: CustomAttribute = master.value(.custom), let slaveCustomStyle: CustomAttribute = slave.value(.custom) {
            let customMerge = customStyle.merge(slave: slaveCustomStyle)
            return ViewStyle([.custom(customMerge)]).merge(slave: merged)
        } else {
            return merged
        }
    }
}
