//
//  Address+Validation.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

public extension Address {

    public enum Error: Swift.Error {
        case tooLong
        case tooShort
        case containsInvalidCharacters
    }

    static func checksum(address hex: HexString) -> String {
        let hash = EllipticCurveKit.Crypto.hash(Data(hex: hex), function: HashFunction.sha256).asHex
        let address = hex.lowercased().droppingLeading0x()
        var checksummed = ""
        for (i, character) in address.enumerated() {
            let index = String.Index(encodedOffset: i)
            let string = String(character)
            let integer = Int(String(hash[index]), radix: 16)!
            if integer >= 8 {
                checksummed += string.uppercased()
            } else {
                checksummed += string
            }
        }
        return checksummed
    }

    static func isAddressChecksummed(_ address: HexString) -> Bool {
        guard
            address.isAddress,
            case let checksummed = checksum(address: address),
            checksummed == address || checksummed == address.droppingLeading0x()
            else { return false }
        return true
    }

    static func isValidAddress(hexString: HexString) -> Bool {
        do {
            try validateAddress(hexString: hexString)
            return true
        } catch {
            return false
        }
    }
    static func validateAddress(hexString: HexString) throws {
        let hex = hexString.droppingLeading0x()
        if hex.count < lengthOfValidAddresses {
            throw Error.tooShort
        }
        if hex.count > lengthOfValidAddresses {
            throw Error.tooLong
        }
        if Number(hexString: hex) == nil {
            throw Error.containsInvalidCharacters
        }
        // is valid
    }
}
