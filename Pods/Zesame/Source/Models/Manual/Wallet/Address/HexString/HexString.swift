// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    var checksummed: LegacyAddress {
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
            let checksummedAddress = try? LegacyAddress(hexString: checksummedHexString) else {
            fatalError("Incorrect implementation")
        }
        return checksummedAddress
    }
}

extension HexString: DataConvertible {}
public extension HexString {
    var asData: Data {
        return Data(hex: self.value)
    }
}

extension HexString: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(try container.decode(String.self))
    }
}
extension HexString: Equatable {}
extension HexString: ExpressibleByStringLiteral {}
public extension HexString {
    init(stringLiteral value: String) {
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
