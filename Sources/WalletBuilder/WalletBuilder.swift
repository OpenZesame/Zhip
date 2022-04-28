//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import ComposableArchitecture
import Foundation
import NamedKeystore
import Password
import Wallet

import struct Zesame.Keystore
import struct Zesame.KeyPair
import struct Zesame.PrivateKey
import struct Zesame.PublicKey

import class Zesame.DefaultZilliqaService
import struct Zesame.Bech32Address
import protocol Zesame.ZilliqaService
import ZilliqaAPIEndpoint


public struct WalletBuilder {
	private let _build: Build
	
	public init(build: @escaping Build) {
		self._build = build
	}
}

public extension WalletBuilder {
	
	enum Error: Swift.Error, Hashable {
		case unknown
	}
	
	func build(namedKeystore: NamedKeystore) -> Effect<Wallet, Error> {
		_build(namedKeystore)
	}
	
	typealias Build = (NamedKeystore) -> Effect<Wallet, Error>
}

public extension WalletBuilder {
	
	static func live(
		zilliqaService: ZilliqaService = DefaultZilliqaService.default,
		jsonEncoder: JSONEncoder = .init()
	) -> Self {
		let build: Build = { namedKeystore in
			
			@Sendable
			func decryptPrivateKey(password: Password) async throws -> KeyPair {
				try await zilliqaService.extractKeyPairFrom(keystore: namedKeystore.keystore, encryptedBy: password.password)
			}
			
			let formatAddress: Wallet.FormatAddress = { format in
				switch format {
				case .legacy: return namedKeystore.keystore.address.asString
				case .mainnet: return try! Bech32Address(ethStyleAddress: namedKeystore.keystore.address).asString
				}
			}
			
			let wallet: Wallet = .init(
				equals: { other in
					let format: AddressFormat = .legacy
					return formatAddress(format) == other.formatAddress(format)
				},
				sign: { signRequest in
//					let privateKey = decryptPrivateKey(password: signRequest.password)
//					let signature = privateKey.sign(message: signRequest.message)
//					return Effect(value: signature)
					fatalError()
				},
				exportKeystoreToJSON: {
					let keystore = namedKeystore.keystore
					let jsonEncoder = JSONEncoder()
					jsonEncoder.outputFormatting = .prettyPrinted
					do {
						let data = try jsonEncoder.encode(keystore)
						let json = String(data: data, encoding: .utf8)!
						return Effect(value: json)
					} catch {
						fatalError("Handle errors")
					}
				},
				exportKeyPair: { request in
					Effect.task {
						let keyPair = try await decryptPrivateKey(password: request.encryptionPassword)
						return KeyPairHex(
							publicKey: keyPair.publicKey.hex.uncompressed,
							privateKey: keyPair.privateKey.asHexStringLength64()
						)
					}
					.mapError(ExportKeyPairError.init(error:))
					.eraseToEffect()
					
				},
				formatAddress: formatAddress,
				name: { namedKeystore.name },
				origin: { namedKeystore.origin }
			)
			
			return Effect(value: wallet)
		}
		
		return Self(build: build)
	}
}
