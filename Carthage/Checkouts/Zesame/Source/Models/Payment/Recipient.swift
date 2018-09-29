//
//  Recipient.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Recipient {
    let address: String
    public init?(string: String) {
        var raw = string
        while raw.starts(with: "0x") {
            raw = String(raw.dropFirst(2))
        }
        guard BigNumber(raw, radix: 16) != nil else { return nil }
        self.address = raw
    }
}
