//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//


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
	
	static func live(zilliqaService: Zesame.ZilliqaService = Zesame.DefaultZilliqaService.default) -> Self {
		Self(generate: { request in
			Effect.task {
				try await zilliqaService.createNewKeystore(
					encryptionPassword: request.password.password,
					kdf: .default,
					kdfParams: .default
				)
			}.map {
				NamedKeystore(keystore: $0, origin: .generatedByThisApp, name: request.name)
			}.mapError { _ -> KeystoreGenerator.Error in
				fatalError()
			}.eraseToEffect()
		
		
		})
	}
}
