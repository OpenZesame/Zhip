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
