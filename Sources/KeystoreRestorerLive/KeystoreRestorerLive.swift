//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import ComposableArchitecture
import Foundation
import NamedKeystore
import KeystoreRestorer
import Password

import struct Zesame.Keystore
import enum Zesame.KeyRestoration
import struct Zesame.PrivateKey

import class Zesame.DefaultZilliqaService
import protocol Zesame.ZilliqaService
import ZilliqaAPIEndpoint


public extension KeystoreRestorer {
	
	static func live(zilliqaService: Zesame.ZilliqaService = Zesame.DefaultZilliqaService.default) -> Self {
	
		
		Self(restore: { request in
			let password = request.password.password
			let keyRestoration: KeyRestoration
			let origin: KeystoreOrigin
			switch request.method {
			case let .restoreFromKeystore(keystoreWithPotentiallyWrongKDF):
				keyRestoration = .keystore(keystoreWithPotentiallyWrongKDF, password: password)
				origin = .importedKeystore
			case let .restoreFromPrivateKey(privateKey):
				keyRestoration = .privateKey(privateKey, encryptBy: password, kdf: .scrypt, kdfParams: .default)
				origin = .importedPrivateKey
			}
			return Effect.task {
				let keystore = try await zilliqaService.restoreKeystore(from: keyRestoration)
				return NamedKeystore(keystore: keystore, origin: origin, name: request.name)
			}.mapError { _ in
				KeystoreRestorer.Error.unknownError
			}
			.eraseToEffect()
		})
	}
}
