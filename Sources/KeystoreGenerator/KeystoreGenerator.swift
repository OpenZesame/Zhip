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

public struct KeystoreGenerator {
	private let _generate: Generate
	public init(
		generate: @escaping Generate
	) {
		self._generate = generate
	}
}

public extension KeystoreGenerator {
	struct Request {
		public let password: Password
		public let name: String?
		public init(
			password: Password,
			name: String?
		) {
			self.password = password
			self.name = name
		}
	}
	
	enum Error: Swift.Error, Hashable {
		case unknownError
	}

}

public extension KeystoreGenerator {
	typealias Generate = (Request) -> Effect<NamedKeystore, KeystoreGenerator.Error>
	
	func generate(request: Request) -> Effect<NamedKeystore, KeystoreGenerator.Error> {
		_generate(request)
	}
}
