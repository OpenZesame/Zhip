//
//  AmountError.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public enum AmountError: Swift.Error {
    case tooSmall(minMagnitudeIs: Double)
    case tooLarge(maxMagnitudeIs: Double)
    case nonNumericString
}
