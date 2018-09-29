//
//  Makeable.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public protocol Makeable: ViewStyling {
    associatedtype View: Styling & StaticEmptyInitializable & UIView
    func merged(other: Self, mode: MergeMode) -> Self
}
public extension Makeable {
    func mergeAttribute<T>(other: Self, path attributePath: KeyPath<Self, T?>, mode: MergeMode) -> T? {
        let selfAttribute = self[keyPath: attributePath]
        let otherAttribute = other[keyPath: attributePath]
        switch mode {
        case .overrideOther: return selfAttribute ?? otherAttribute
        case .yieldToOther: return otherAttribute ?? selfAttribute
        }
    }
}
