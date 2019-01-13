//
//  AddressNotNecessarilyChecksummed.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public struct AddressNotNecessarilyChecksummed: AddressChecksummedConvertible {

    public let hexString: HexString

    // AddressChecksummedConvertible init
    public init(hexString: HexStringConvertible) throws {
        try AddressNotNecessarilyChecksummed.validate(hexString: hexString)
        self.hexString = hexString.hexString
    }
}

// MARK: - AddressChecksummedConvertible
public extension AddressNotNecessarilyChecksummed {
    var checksummedAddress: AddressChecksummed {
        let checksummedHexString = AddressChecksummed.checksummedHexstringFrom(hexString: hexString)
        do {
            return try AddressChecksummed(hexString: checksummedHexString)
        } catch {
            fatalError("Should be able to checksum address, unexpected error: \(error)")
        }
    }
}

// MARK: - Equatable
extension AddressNotNecessarilyChecksummed: Equatable {}
