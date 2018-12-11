//
//  KeyRestoration.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public enum KeyRestoration {
    case privateKey(PrivateKey, encryptBy: String)
    case keystore(Keystore, passphrase: String)
}

public extension KeyRestoration {

    init(privateKeyHexString: String, encryptBy newPasshrase: String) throws {
        guard let privateKey = PrivateKey(hex: privateKeyHexString) else {
            throw Error.walletImport(.badPrivateKeyHex)
        }
        self = .privateKey(privateKey, encryptBy: newPasshrase)
    }

    init(keyStoreJSON: Data, encryptedBy passphrase: String) throws {
        do {
            let keystore = try JSONDecoder().decode(Keystore.self, from: keyStoreJSON)
            self = .keystore(keystore, passphrase: passphrase)
        } catch let error as Swift.DecodingError {
            throw Error.walletImport(.jsonDecoding(error))
        } catch { fatalError("incorrect implementation") }
    }

    init(keyStoreJSONString: String, encodedBy encoding: String.Encoding = .utf8, encryptedBy passphrase: String) throws {
        guard let json = keyStoreJSONString.data(using: encoding) else {
            throw Error.walletImport(.jsonStringDecoding)
        }

        try self.init(keyStoreJSON: json, encryptedBy: passphrase)
    }
}
