//
//  Recipient.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Recipient {
    public let address: String
    public init(address: Address) {
        self.address = address.checksummedHex.droppingLeading0x().uppercased()
    }
}
