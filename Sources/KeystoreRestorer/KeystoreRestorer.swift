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

import struct Zesame.Keystore
import struct Zesame.PrivateKey

public struct KeystoreRestorer {
	private let _restore: Restore
	public init(restore: @escaping Restore) {
		self._restore = restore
	}
}


public extension KeystoreRestorer {
	
	
	enum Error: Swift.Error {
		case unknownError
	}
	
	
	struct Request {
		public enum Method {
			case restoreFromPrivateKey(PrivateKey)
			case restoreFromKeystore(Keystore)
		}
		public let method: Method
		public let password: Password
		public let name: String?
		
		public init(
			method: Method,
			password: Password,
			name: String?
		) {
			self.method = method
			self.password = password
			self.name = name
		}
	}
	
	func restore(request: Request) -> Effect<NamedKeystore, KeystoreRestorer.Error> {
		self._restore(request)
	}

	
	typealias Restore = (Request) -> Effect<NamedKeystore, KeystoreRestorer.Error>
}
 

