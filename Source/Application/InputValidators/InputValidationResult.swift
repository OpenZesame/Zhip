//
//  InputValidationResult.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum InputValidationResult<Value> {
    case valid(Value)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case error(message: String)
    }
}

protocol InputError: Swift.Error {
    var errorMessage: String { get }
}
