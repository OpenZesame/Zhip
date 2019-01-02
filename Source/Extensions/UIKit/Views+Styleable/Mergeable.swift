//
//  Mergeable.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public protocol Mergeable {
    func merged(other: Self, mode: MergeMode) -> Self
}

extension Mergeable {
    func merge(yieldingTo other: Self?) -> Self {
        guard let other = other else { return self }
        return merge(yieldingTo: other)
    }

    func merge(yieldingTo other: Self) -> Self {
        return merged(other: other, mode: .yieldToOther)
    }

    func merge(overridingOther other: Self?) -> Self {
        guard let other = other else { return self }
        return merge(overridingOther: other)
    }

    func merge(overridingOther other: Self) -> Self {
        return merged(other: other, mode: .overrideOther)
    }
}

public extension Mergeable {
    func mergeAttribute<T>(other: Self, path attributePath: KeyPath<Self, T?>, mode: MergeMode) -> T? {
        let selfAttribute = self[keyPath: attributePath]
        let otherAttribute = other[keyPath: attributePath]
        switch mode {
        case .overrideOther: return selfAttribute ?? otherAttribute
        case .yieldToOther: return otherAttribute ?? selfAttribute
        }
    }
}

public enum MergeMode {
    case overrideOther
    case yieldToOther
}

extension Optional where Wrapped: Mergeable {
    func merge(overridingOther other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .overrideOther)
    }

    func merge(yieldingTo other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .yieldToOther)
    }

    private func merged(other: Wrapped, mode: MergeMode) -> Wrapped {
        guard let `self` = self else { return other }
        return `self`.merged(other: other, mode: mode)
    }
}
