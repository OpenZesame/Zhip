//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-19.
//

import Foundation
import Common
import ComposableArchitecture
import struct Zesame.Amount
import PIN

public struct KeychainClient {
	public var dataForKey: (String) -> Effect<Data?, Self.Error>
	public var remove: (String) -> Effect<Void, Self.Error>
	public var setData: (Data, String) -> Effect<Void, Self.Error>
}

// MARK: - Codable
// MARK: -
public extension KeychainClient {
	
	enum Error: LocalizedError, Hashable {
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
	func saveWalletData(_ data: Data) -> Effect<Void, Self.Error> {
		setData(data, walletKey)
	}
	
	func loadWalletData() -> Effect<Data?, Self.Error> {
		dataForKey(walletKey)
	}
	
	func removeWalletData() -> Effect<VoidEq, Self.Error> {
		remove(walletKey)
			.map(VoidEq.init)
			.eraseToEffect()
	}
	
	func removeAll() -> Effect<Never, Never> {
		Effect.merge(
			allKeys.map {
				self.remove($0)
					.replaceError(with: ())
					.fireAndForget()
					.eraseToEffect()
			}
		)
	}
}

// MARK: - Balance
// MARK: -
public extension KeychainClient {
	func saveBalance(_ amount: Amount) -> Effect<Amount, Self.Error> {
		save(model: amount, forKey: balanceKey)
	}
	
	func loadBalance() -> Effect<Amount?, Self.Error> {
		load(type: Amount.self, forKey: balanceKey)
	}
}

// MARK: - PIN
// MARK: -
public extension KeychainClient {
	func savePIN(_ pin: PIN) -> Effect<PIN, Self.Error> {
		save(model: pin, forKey: pinKey)
	}
	
	func loadPIN() -> Effect<PIN?, Self.Error> {
		load(type: PIN.self, forKey: pinKey)
	}
}

private let walletKey = "walletKey"
private let balanceKey = "balanceKey"
private let pinKey = "pinKey"

private let allKeys = [
	walletKey,
	balanceKey,
	pinKey
]
