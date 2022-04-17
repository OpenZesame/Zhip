//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import NamedKeystore

public struct KeystoreToFileWriter {
	
	private let _write: Write
	public init(write: @escaping Write) {
		self._write = write
	}
}

public extension KeystoreToFileWriter {
	
	enum Error: Swift.Error {
		case failedToJSONEncode(EncodingError)
		case failedToSaveDataInKeychain(KeychainClient.Error)
	}
	
	typealias Write = (NamedKeystore) -> Effect<NamedKeystore, Error>
	
	func write(keystore: NamedKeystore) -> Effect<NamedKeystore, Error> {
		_write(keystore)
	}
}

public extension KeystoreToFileWriter {
	static func live(
		keychain: KeychainClient,
		jsonEncoder: JSONEncoder = .init()
	) -> Self {
		let write: Write = { namedKeystore in
			do {
				let data = try jsonEncoder.encode(namedKeystore)
				return keychain.saveWalletData(data).mapError {
					Error.failedToSaveDataInKeychain($0)
				}
				.map { _ in namedKeystore }
				.eraseToEffect()
			} catch let jsonEncodingError as EncodingError {
				return Effect(error: Error.failedToJSONEncode(jsonEncodingError))
			} catch {
				fatalError("expected EncodingError error")
			}
		}
		return Self(write: write)
	}
}
