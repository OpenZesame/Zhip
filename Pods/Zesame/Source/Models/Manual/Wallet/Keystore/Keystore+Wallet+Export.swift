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
import EllipticCurveKit
import Result

public extension Keystore {
    static func from(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptBy password: String, done: @escaping Done<Keystore>) {
        guard password.count >= Keystore.minumumPasswordLength else { done(.failure(.keystorePasswordTooShort(provided: password.count, minimum: Keystore.minumumPasswordLength))); return }

        // Same parameters used by Zilliqa Javascript SDK: https://github.com/Zilliqa/Zilliqa-Wallet/blob/master/src/app/zilliqa.service.ts#L142
        let salt = try! securelyGenerateBytes(count: 32).asData

        let kdfParams = Keystore.Crypto.KeyDerivationFunctionParameters(
            costParameter: isDebug ? 2048 : 262144,
            blockSize: 1,
            parallelizationParameter: 8,
            lengthOfDerivedKey: 32,
            saltHex: salt.asHex
        )

        Scrypt(kdfParameters: kdfParams).deriveKey(password: password) { derivedKey in
            let keyStore = Keystore(from: derivedKey, address: address, privateKey: privateKey, parameters: kdfParams)
            done(Result.success(keyStore))
        }
    }
}
