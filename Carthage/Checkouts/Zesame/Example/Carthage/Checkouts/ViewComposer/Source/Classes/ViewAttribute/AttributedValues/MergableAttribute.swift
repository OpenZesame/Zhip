//
//  MergableAttribute.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-08-03.
//
//

import Foundation

public protocol MergeableAttribute {
    func merge(overwrittenBy other: Self) -> Self
}
