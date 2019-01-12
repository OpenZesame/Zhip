//
//  AddressChecksummed.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-05.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct AddressChecksummed: AddressChecksummedConvertible {

    public let checksummed: HexString

    // AddressChecksummedConvertible init
    public init(hexString: HexStringConvertible) throws {
        guard AddressChecksummed.isChecksummed(hexString: hexString) else {
            throw Address.Error.notChecksummed
        }
        self.checksummed = hexString.hexString
    }
}

// MARK: AddressChecksummedConvertible
public extension AddressChecksummed {
    var checksummedAddress: AddressChecksummed { return self }
}

// MARK: Equatable
extension AddressChecksummed: Equatable {}
