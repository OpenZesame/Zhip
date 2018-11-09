//
//  Keystore+Wallet+Export.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit
import Result

public extension Keystore {
    static func from(address: Address, privateKey: PrivateKey, encryptBy passphrase: String, done: @escaping Done<Keystore>) {
        guard passphrase.count >= Keystore.minumumPasshraseLength else { done(.failure(.keystorePasshraseTooShort(provided: passphrase.count, minimum: Keystore.minumumPasshraseLength))); return }

        // Same parameters used by Zilliqa Javascript SDK: https://github.com/Zilliqa/Zilliqa-Wallet/blob/master/src/app/zilliqa.service.ts#L142
        let salt = try! securelyGenerateBytes(count: 32).asData
        let kdfParams = Keystore.Crypto.KeyDerivationFunctionParameters(
            costParameter: 2048,
            blockSize: 1,
            parallelizationParameter: 8,
            lengthOfDerivedKey: 32,
            saltHex: salt.asHex
        )

        Scrypt(kdfParameters: kdfParams).deriveKey(passphrase: passphrase) { derivedKey in
            let keyStore = Keystore(from: derivedKey, address: address, privateKey: privateKey, parameters: kdfParams)
            done(Result.success(keyStore))
        }
    }
}
