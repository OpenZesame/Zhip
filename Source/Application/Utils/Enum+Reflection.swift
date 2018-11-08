//
//  Enum+Reflection.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

func findNestedEnumOfType<Nested>(_ wantedType: Nested.Type, in parent: Any, recursiveTriesLeft: Int) -> Nested? {
    guard recursiveTriesLeft >= 0 else { return nil }

    guard
        case let mirror = Mirror(reflecting: parent),
        let displayStyle = mirror.displayStyle,
        displayStyle == .enum,
        let child = mirror.children.first
        else { return nil }

    guard let needle = child.value as? Nested
        else { return findNestedEnumOfType(wantedType, in: parent, recursiveTriesLeft: recursiveTriesLeft - 1) }

    return needle
}
