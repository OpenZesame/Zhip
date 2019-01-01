//
//  GasLimit.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public typealias GasLimit = Int
public extension GasLimit {
    static var defaultGasLimit: GasLimit {
        return 1
    }
}
