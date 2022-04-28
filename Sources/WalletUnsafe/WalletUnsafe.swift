//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-18.
//

import ComposableArchitecture
import Common
import Foundation
import NamedKeystore
import Wallet
import Zesame
import ZilliqaAPIEndpoint

#if DEBUG
public extension Wallet {
	static let unsafe︕！Wallet: Self = {
		let unsafestPrivateKey = PrivateKey(number: 1)!
		let keyPair = KeyPair.init(private: unsafestPrivateKey)
		let publicKeyOfUnsafePrivateKey = keyPair.publicKey
		let address = LegacyAddress(publicKey: publicKeyOfUnsafePrivateKey)
		return Self(
			equals: { _ in false },
			sign: { signRequest in
//				AnyKeySigner<ECDSA<Secp256k1>>.sign(signRequest, using: keyPair)
				fatalError()
			},
			exportKeystoreToJSON: {
				// The following JSON is NOT the correct keystore for the private key of 1. Which you see since it is just deadbeef
let jsonString = """
{
	"version": 3,
	"id": "257C9125-7CAD-4FFD-850F-11DFC0187EEA",
	"crypto":
	{
		"ciphertext": "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
		"cipherparams":
		{
			"iv": "6606417d1eb40d372aa56543a747288a"
		},
		"kdf": "pbkdf2",
		"kdfparams":
		{
			"r": 8,
			"p": 1,
			"n": 1,
			"c": 1,
			"dklen": 32,
			"salt": "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
		},
		"mac": "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
		"cipher": "aes-128-ctr"
	},
	"address": "29e562f73488c8a2bB9Dbc5700b361D54b9B0554"
}
"""
				return Effect(value: jsonString)
			},
			exportKeyPair: { request in
				Effect(
					value: KeyPairHex(
						publicKey: "03deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
						privateKey: unsafestPrivateKey.asHexStringLength64()
					)
				)
			},
			formatAddress: { format in
				switch format {
				case .mainnet: return try! Bech32Address(ethStyleAddress: address, network: .mainnet).asString
				case .legacy: return address.asString
				}
			},
			name: { "UnsafeDebug" },
			origin: { KeystoreOrigin.generatedByThisApp }
		)
	}()
}
#endif
