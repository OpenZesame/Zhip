//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-28.
//

import Foundation
import ComposableArchitecture
import KeystoreToFileWriter
import KeystoreRestorer
import Password

import Wallet
import WalletBuilder

import enum Zesame.KeyRestoration
import struct Zesame.Keystore
import typealias Zesame.PrivateKey


public struct WalletRestorer {
	
	public typealias Restore = (Request) -> Effect<Wallet, WalletRestorer.Error>
	
	public let _restore: Restore

	public init(
		restore: @escaping Restore
	) {
		self._restore = restore
	}
}

public extension WalletRestorer {
	
	func restore(request: Request) -> Effect<Wallet, WalletRestorer.Error> {
		self._restore(request)
	}
	
	enum Error: Swift.Error, Hashable {
		case failedToRestore(KeystoreRestorer.Error)
		case failedToPersist(KeystoreToFileWriter.Error)
		case failedToBuildWallet(WalletBuilder.Error)
	}
	
	struct Request {
		
		public enum Method {
			case privateKey(PrivateKey)
			case keystore(Keystore)
		}
		
		public let method: Method
		public let password: Password
		public let name: String?
		public init(
			method: Method,
			password: Password,
			name: String? = nil
		) {
			self.method = method
			self.password = password
			self.name = name
		}
	}
}
