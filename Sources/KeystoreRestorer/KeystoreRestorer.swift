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

public struct RestoreKeystoreRequest {
	public enum Method {
		case restoreFromPrivateKey(PrivateKey)
		case restoreFromKeystore(Keystore)
	}
	public let method: Method
	public let password: Password
	public let name: String?
}


public extension KeystoreRestorer {
	
	
	enum Error: Swift.Error {
		case unknownError
	}
	
	typealias Restore = (RestoreKeystoreRequest) -> Effect<NamedKeystore, KeystoreRestorer.Error>
}
 

