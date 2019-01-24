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
