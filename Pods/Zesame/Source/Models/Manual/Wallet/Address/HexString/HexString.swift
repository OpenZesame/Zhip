//
//  Address+HexString.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension CharacterSet {
    static var hexadecimalDigits: CharacterSet {
        let afToAF = CharacterSet(charactersIn: "abcdefABCDEF")
        return CharacterSet.decimalDigits.union(afToAF)
    }
}

public struct HexString {

    public let value: String
    init(_ value: String) throws {
        let value = value.droppingLeading0x()
        guard CharacterSet.hexadecimalDigits.isSuperset(of: CharacterSet(charactersIn: value)) else {
            throw Address.Error.notHexadecimal
        }
        self.value = value
    }
}

import EllipticCurveKit
public extension HexString {

    // Checksums a Zilliqa address, implementation is based on Javascript library:
    // https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/9368fb34a0d443797adc1ecbcb9728db9ce75e97/packages/zilliqa-js-crypto/src/util.ts#L76-L96
    var checksummed: AddressChecksummed {
        let string = value
        let numberFromHash = EllipticCurveKit.Crypto.hash(Data(hex: string), function: HashFunction.sha256).asNumber
        var checksummedString: String = ""
        for (i, character) in string.enumerated() {
            let string = String(character)
            let characterIsLetter = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: string))
            guard characterIsLetter else {
                checksummedString += string
                continue
            }
            let andOperand: Number = Number(2).power(255 - 6 * i)
            let shouldUppercase = (numberFromHash & andOperand) >= 1
            checksummedString += shouldUppercase ? string.uppercased() : string.lowercased()
        }

        guard
            let checksummedHexString = try? HexString(checksummedString),
            let checksummedAddress = try? AddressChecksummed(hexString: checksummedHexString) else {
            fatalError("Incorrect implementation")
        }
        return checksummedAddress
    }
}

extension HexString: Codable {}
extension HexString: Equatable {}
extension HexString: ExpressibleByStringLiteral {}
public extension HexString {
    public init(stringLiteral value: String) {
        do {
            try self.init(value)
        } catch {
            fatalError("String value: `\(value)` passed is not a valid hexadecimal string, error: \(error)")
        }
    }
}

//public typealias HexString = String

public extension String {
    func droppingLeading0x() -> String {
        var string = self
        while string.starts(with: "0x") {
            string = String(string.dropFirst(2))
        }
        return string
    }

//    var isAddress: Bool {
//        return Address.isValidAddress(hexString: self)
//    }
}

public extension HexString {
    var length: Int {
        return value.count
    }
}
extension HexString: CustomStringConvertible {}
public extension HexString {
    var description: String {
        return value
    }
}
