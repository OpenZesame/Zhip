//
//  AmountError.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public enum AmountError<E: ExpressibleByAmount>: Swift.Error {
    case tooSmall(min: E)
    case tooLarge(max: E)
    case nonNumericString
}
