//
//  Address+CustomStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - CustomStringConvertible
extension Address: CustomStringConvertible {}
public extension Address {
    var description: String {
        let checksummedOrNot: String = self.isChecksummed ? "Checksummed" : "Not checksummed"
        return "\(checksummedOrNot) address: \(self.hexString.value)"
    }
}
