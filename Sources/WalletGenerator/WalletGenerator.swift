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
	
	enum Error: Swift.Error, Hashable {
		case failedToGenerate(KeystoreGenerator.Error)
		case failedToPersist(KeystoreToFileWriter.Error)
		case failedToBuildWallet(WalletBuilder.Error)
	}
	
	typealias Generate = (Request) -> Effect<Wallet, WalletGenerator.Error>
	
	func generate(request: Request) -> Effect<Wallet, WalletGenerator.Error> {
		_generate(request)
	}
}
