//
//  Address.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-05.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import CryptoSwift
import EllipticCurveKit

public struct Address {
    public static let lengthOfValidAddresses: Int = 40

    /// The compressed hashed data as a hexadecimal string
    /// which checksum has been confirmed to be correct.
    public let checksummedHex: HexString

    public init(hexString: HexString) throws {
        try Address.validateAddress(hexString: hexString)
        self.checksummedHex = Address.checksum(address: hexString)
    }
}

public extension Address {

    init(compressedHash: Data) throws {
        try self.init(hexString: compressedHash.toHexString())
    }

    init(publicKey: PublicKey, network: Network) {
        let system = EllipticCurveKit.Zilliqa(network)
        let compressedHash = system.compressedHash(from: publicKey)
        do {
            try self.init(compressedHash: compressedHash)
        } catch {
            fatalError("Incorrect implementation, using `publicKey:network` initializer should never result in error: `\(error)`")
        }
    }

    init(keyPair: KeyPair, network: Network) {
        self.init(publicKey: keyPair.publicKey, network: network)
    }
}

public extension Address {

    public enum Error: Swift.Error {
        case tooLong
        case tooShort
        case containsInvalidCharacters
    }

    static func checksum(address hex: HexString) -> String {
        let hash = EllipticCurveKit.Crypto.hash(Data(hex: hex), function: HashFunction.sha256).asHex
        let address = hex.lowercased().droppingLeading0x()
        var checksummed = "0x"
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
            checksummed == address || checksummed.droppingLeading0x() == address
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

