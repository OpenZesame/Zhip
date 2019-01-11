//
//  InputError.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public protocol InputError: Swift.Error, CustomStringConvertible {
    var errorMessage: String { get }
    func isEqual(_ error: InputError) -> Bool
}

public extension CustomStringConvertible where Self: InputError {
    var description: String {
        return errorMessage
    }
}

public extension InputError {
    func isEqual(_ error: InputError) -> Bool {
        return true
    }
}
