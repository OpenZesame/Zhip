//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-19.
//

import Foundation
import ComposableArchitecture
import Wallet
import struct Zesame.ZilAmount
import PINCode

public struct KeychainClient {
	public var dataForKey: (String) -> Effect<Data?, Self.Error>
	public var remove: (String) -> Effect<Void, Self.Error>
	public var setData: (Data, String) -> Effect<Void, Self.Error>
}

// MARK: - Codable
// MARK: -
public extension KeychainClient {
	
	enum Error: LocalizedError, Equatable {
		case keychainRemoveError(reason: String)
		case keychainReadError(reason: String)
		case keychainWriteError(reason: String)
		case encodeModelFailed(reason: String)
		case decodeModelFailed(reason: String)
	}
	
	func save<Model: Codable>(
		model: Model,
		forKey key: String,
		encoder: JSONEncoder = .init()
	) -> Effect<Model, Self.Error> {
		return Effect<Model, EncodingError>(value: model)
			.encode(encoder: encoder)
			.mapError { error in
				Self.Error.encodeModelFailed(
					reason: String(describing: error)
				)
			}
			.flatMap { (data: Data) -> Effect<Void, Self.Error> in
				return setData(data, key)
			}
			.map { _ in
				return model
			}
			.eraseToEffect()
	}
	
	func load<Model: Codable>(
		type modelType: Model.Type,
		forKey key: String,
		decoder: JSONDecoder = .init()
	) -> Effect<Model?, Self.Error> {
		dataForKey(key).flatMap { (maybeData: Data?) -> Effect<Model?, Self.Error> in
			guard let data = maybeData else {
				return Effect(value: nil)
			}
			do {
				return Effect(value: try decoder.decode(Model.self, from: data))
			} catch {
				return Effect(
					error: Self.Error.decodeModelFailed(reason: String(describing: error))
				)
			}
		}.eraseToEffect()


	}
	
}

// MARK: - Wallet
// MARK: -
public extension KeychainClient {
	func saveWallet(_ wallet: Wallet) -> Effect<Wallet, Self.Error> {
		save(model: wallet, forKey: walletKey)
	}
	
	func loadWallet() -> Effect<Wallet?, Self.Error> {
		load(type: Wallet.self, forKey: walletKey)
	}
}

// MARK: - Balance
// MARK: -
public extension KeychainClient {
	func saveBalance(_ amount: ZilAmount) -> Effect<ZilAmount, Self.Error> {
		save(model: amount, forKey: balanceKey)
	}
	
	func loadBalance() -> Effect<ZilAmount?, Self.Error> {
		load(type: ZilAmount.self, forKey: balanceKey)
	}
}

// MARK: - PIN
// MARK: -
public extension KeychainClient {
	func savePIN(_ pin: Pincode) -> Effect<Pincode, Self.Error> {
		save(model: pin, forKey: pinCodeKey)
	}
	
	func loadPIN() -> Effect<Pincode?, Self.Error> {
		load(type: Pincode.self, forKey: pinCodeKey)
	}
}

private let walletKey = "walletKey"
private let balanceKey = "balanceKey"
private let pinCodeKey = "pinCodeKey"
