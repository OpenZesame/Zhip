//
//  Amount_Extension.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

extension Amount {
    static var minimumAsDouble: Double {
        return 1 / pow(10, Double(Amount.decimals))
    }

    static var maximumAsDouble: Double {
        return Amount.totalSupply
    }
}
