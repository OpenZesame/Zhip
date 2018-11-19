//
//  AssociatedObject.swift
//  Zupreme
//
//  Created by Andrei Radulescu on 11/19/18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

func associatedObject<ValueType: AnyObject>(_ base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType)
    -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType { return associated }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType: AnyObject>(_ base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}
