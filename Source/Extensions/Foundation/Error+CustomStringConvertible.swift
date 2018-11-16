//
//  Error+CustomStringConvertible.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Swift.Error where Self: CustomStringConvertible {
    var description: String {
        if isEnum(type: self) {
            guard let nameOfEnumCase = nameOf(enumCase: self) else { incorrectImplementation("Fix the code that recursivly extracts name of nested enums, it contains some bug.") }
            return nameOfEnumCase
        } else {
            incorrectImplementation("You need to implement `CustomStringConvertible` by adding a `description: String`")
        }
    }
}
