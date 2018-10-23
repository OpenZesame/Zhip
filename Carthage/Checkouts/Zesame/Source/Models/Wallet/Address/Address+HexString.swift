//
//  Address+HexString.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public typealias HexString = String

extension HexString {
    func droppingLeading0x() -> HexString {
        var string = self
        while string.starts(with: "0x") {
            string = String(string.dropFirst(2))
        }
        return string
    }

    var isAddress: Bool {
        return Address.isValidAddress(hexString: self)
    }
}
