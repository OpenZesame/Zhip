//
//  Weak.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Box referencing a value, without retaining it
final class Weak<Value: AnyObject> {
    private(set) weak var value: Value?
    init(_ value: Value) {
        self.value = value
    }
}
