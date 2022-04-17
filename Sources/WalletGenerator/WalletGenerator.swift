//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-15.
//

import ComposableArchitecture
import KeystoreGenerator
import KeystoreToFileWriter
import Password
import Wallet
import WalletBuilder

public struct WalletGenerator {
	private let _generate: Generate
	public init(generate: @escaping Generate) {
		self._generate = generate
	}
}

public extension WalletGenerator {
	
	struct Request {
		public let password: Password
		public let name: String?
		
		public init (
			password: Password,
			name: String?
		) {
			self.password = password
			self.name = name
		}
	}
	
	enum Error: LocalizedError, Equatable {
		case invalidEncryptionPassword
		case internalError(error: String)
		
		public var errorDescription: String? {
			switch self {
			case .invalidEncryptionPassword:
				return "Encryption password does not meet minimum safety requirements. Try a longer and safer password."
			case let .internalError(underlyingError):
				return "Internal error, reason: \(underlyingError)"
			}
		}
	}
	
	typealias Generate = (Request) -> Effect<Wallet, WalletGenerator.Error>
	
	func generate(request: Request) -> Effect<Wallet, WalletGenerator.Error> {
		_generate(request)
	}
}
