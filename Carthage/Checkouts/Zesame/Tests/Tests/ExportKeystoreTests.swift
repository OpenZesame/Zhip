//
//  ExportKeystoreTests.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import XCTest
@testable import Zesame

class ExportKeystoreTest: XCTestCase {

    func testDecodeKeystoreJson() {
        let decoded = try! JSONDecoder().decode(Keystore.self, from: keystoreWalletJson)
        XCTAssertEqual(decoded.crypto.cipherParameters.initializationVectorHex, "8c361b7b3f41109e1ec5d82fbecd8bcd")
        XCTAssertEqual(decoded.crypto.encryptedPrivateKeyHex, "80fe61275f7a4078c7fcaafeda0c108f1b79335fa320b0d4b07bcba128f0bdd5")
        XCTAssertEqual(decoded.crypto.messageAuthenticationCodeHex, "6450a59b8d4bcd27d3ea42cd40b8722cc5ddd0482645cf0e2053fdb498cfcc3b")
        XCTAssertEqual(decoded.crypto.keyDerivationFunctionParameters.saltHex, "95e3b71845b4f6410407764216c63467c7543c46792d21e14723f0ad452683d0")
    }

    func testWalletImport() {
        let expectedPrivateKey = "45EE46BDB0E3BC9107860AAA8BD443C3C745E2C2DC8AF63492D4C8896C06E864"
        let passphrase = "test_of_export_of_wallet_to_keystore_file_json_example_passphrase"
        let service = DefaultZilliqaService.shared
        let sempaphore = expectation(description: "importing wallet from keystore json")
        service.importWalletFrom(keyStoreJSONString: keystoreWalletJSONString, encryptedBy: passphrase) {
            switch $0 {
            case .success(let importedWallet): XCTAssertEqual(importedWallet.keyPair.privateKey.asHexStringLength64(), expectedPrivateKey)
            case .failure(let error): XCTFail("Failed to export, error: \(error)")
            }
            sempaphore.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}

private let keystoreWalletJSONString = """
{
"address": "10795a368fbc4d4dd64abf2fe534381cef1041f3",
"crypto": {
"cipher": "aes-128-ctr",
"cipherparams": {
"iv": "8c361b7b3f41109e1ec5d82fbecd8bcd"
},
"ciphertext": "80fe61275f7a4078c7fcaafeda0c108f1b79335fa320b0d4b07bcba128f0bdd5",
"kdf": "scrypt",
"kdfparams": {
"dklen": 32,
"n": 262144,
"r": 1,
"p": 8,
"salt": "95e3b71845b4f6410407764216c63467c7543c46792d21e14723f0ad452683d0"
},
"mac": "6450a59b8d4bcd27d3ea42cd40b8722cc5ddd0482645cf0e2053fdb498cfcc3b"
},
"id": "1ae9ecfb-ada3-45ff-96ff-b7c269f1b247",
"version": 3
}
"""
private let keystoreWalletJson = keystoreWalletJSONString.data(using: .utf8)!
