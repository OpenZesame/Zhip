//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import CryptoSwift
import EllipticCurveKit

// MARK: - Validation
public extension AddressChecksummed {
    static func isChecksummed(hexString: HexStringConvertible) -> Bool {
        guard
            hexString.isValidAddressButNotNecessarilyChecksummed,
            case let checksummed = checksummedHexstringFrom(hexString: hexString),
            checksummed == hexString
            else { return false }
        return true
    }

    // Checksums a Zilliqa address, implementation is based on Javascript library:
    // https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/9368fb34a0d443797adc1ecbcb9728db9ce75e97/packages/zilliqa-js-crypto/src/util.ts#L76-L96
    static func checksummedHexstringFrom(hexString: HexStringConvertible) -> HexString {
        let string = hexString.asString
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

        do {
            return try HexString(checksummedString)
        } catch {
            fatalError("Should be hexstring, unexpected error: \(error)")
        }
    }
}
