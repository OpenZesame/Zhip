//
//  ReflectionNameOfCaseInNestedEnum.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

func nameOf(enumCase enumToMirror: Any) -> String? {
    guard isEnum(type: enumToMirror) else { return nil }
    let mirror = Mirror(reflecting: enumToMirror)
    if let enumCase = mirror.children.first {
        return enumCase.label ?? (enumCase.value as? String)
    } else {
        return String(describing: enumToMirror)
    }
}

func isEnum(type: Any) -> Bool {
    let mirror = Mirror(reflecting: type)
    guard
        let displayStyle = mirror.displayStyle,
        displayStyle == .enum
        else { return false }
    return true
}
