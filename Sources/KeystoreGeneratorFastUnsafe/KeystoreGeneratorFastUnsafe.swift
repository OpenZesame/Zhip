//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-17.
//

#if DEBUG
import ComposableArchitecture
import Foundation
import NamedKeystore
import KeystoreGenerator
import Password

import struct Zesame.Keystore
import struct Zesame.PrivateKey

import class Zesame.DefaultZilliqaService
import protocol Zesame.ZilliqaService
import ZilliqaAPIEndpoint


public extension KeystoreGenerator {
	
	static func fast︕！Unsafe(
		zilliqaService: Zesame.ZilliqaService = Zesame.DefaultZilliqaService.default
	) -> Self {
		Self(generate: { request in
			Effect.task {
				try await zilliqaService.createNewKeystore(
					encryptionPassword: request.password.password,
					kdf: .unsafeFast,
					kdfParams: .unsafeFast
				)
			}.map {
				NamedKeystore(keystore: $0, origin: .generatedByThisApp, name: request.name)
			}.mapError { _ -> KeystoreGenerator.Error in
				fatalError()
			}.eraseToEffect()
		
		
		})
	}
}
#else
private enum Inhabited {}
#endif // DEBUG
