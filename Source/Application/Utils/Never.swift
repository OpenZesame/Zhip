//
//  Never.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

var interfaceBuilderSucks: Never {
    fatalError("interfaceBuilderSucks")
}

func incorrectImplementation(_ message: CustomStringConvertible) -> Never {
    fatalError("Incorrect implementation - \(message.description)")
}

var abstract: Never {
    fatalError("Override me")
}
