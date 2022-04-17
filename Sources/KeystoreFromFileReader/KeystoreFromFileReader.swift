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

public struct KeystoreFromFileReader {
	
	private let _read: Read
	public init(read: @escaping Read) {
		self._read = read
	}
}

public extension KeystoreFromFileReader {
	
	enum Error: Swift.Error {
		case failedToJSONDecode(DecodingError)
	}
	
	typealias Read = () -> Effect<NamedKeystore?, Error>
	
	func read() -> Effect<NamedKeystore?, Error> {
		_read()
	}
}

public extension KeystoreFromFileReader {
	static func live(
		keychain: KeychainClient,
		jsonDecoder: JSONDecoder = .init()
	) -> Self {
		let read: Read = { () -> Effect<NamedKeystore?, Error> in
			keychain.loadWalletData().tryMap {
				guard let data = $0 else { return nil }
				return try jsonDecoder.decode(NamedKeystore.self, from: data)
			}.mapError {
				guard let jsonDecodingError = $0 as? DecodingError else {
					fatalError("expected DecodingError error")
				}
				return Error.failedToJSONDecode(jsonDecodingError)
			}.eraseToEffect()
			
		}
		return Self(read: read)
	}
}
