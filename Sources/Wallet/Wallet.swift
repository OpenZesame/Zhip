//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-11.
//

import ComposableArchitecture
import Foundation
import Password
import NamedKeystore

public struct KeyPairHex: Equatable {
	public let publicKey: String
	public let privateKey: String
	public init(publicKey: String, privateKey: String) {
		self.publicKey = publicKey
		self.privateKey = privateKey
	}
}

public struct Wallet: Equatable {
	public let equals: Equals
	public let sign: Sign
	public let exportKeystoreToJSON: ExportKeystoreToJSON
	public let exportKeyPair: ExportKeyPair
	public let formatAddress: FormatAddress
	public let name: Name
	public let origin: Origin
	
	public init(
		equals: @escaping Equals,
		sign: @escaping Sign,
		exportKeystoreToJSON: @escaping ExportKeystoreToJSON,
		exportKeyPair: @escaping ExportKeyPair,
		formatAddress: @escaping FormatAddress,
		name: @escaping Name,
		origin: @escaping Origin
	) {
		self.equals = equals
		self.sign = sign
		self.exportKeystoreToJSON = exportKeystoreToJSON
		self.exportKeyPair = exportKeyPair
		self.formatAddress = formatAddress
		self.name = name
		self.origin = origin
	}
}


public extension Wallet {
	typealias FormatAddress = (AddressFormat) -> String
	typealias Equals = (_ other: Self) -> Bool
	typealias Sign = (SignRequest) -> Effect<Bool, Never>
	typealias ExportKeystoreToJSON = () -> Effect<String, Never>
	typealias ExportKeyPair = (ExportPrivateKeyRequest) -> Effect<KeyPairHex, Never>
	typealias Name = () -> String?
	typealias Origin = () -> KeystoreOrigin
}

public extension Wallet {
	func address(_ format: AddressFormat = .mainnet) -> String {
		formatAddress(format)
	}
}

public enum AddressFormat {
	/// Eth formatting, like: `0x...`
	case legacy
	
	/// Mainnet Zil bech32 format like: `zil1....`
	case mainnet
}

public struct SignRequest {
	public let encryptionPassword: Password
	public init(
		encryptionPassword: Password
	) {
		self.encryptionPassword = encryptionPassword
	}
}

public struct ExportPrivateKeyRequest {
	public let encryptionPassword: Password
	public init(
		encryptionPassword: Password
	) {
		self.encryptionPassword = encryptionPassword
	}
}


// MARK: Equatable
public extension Wallet {
	static func == (lhs: Self, rhs: Self) -> Bool {
		guard lhs.equals(rhs) else {
			assert(!rhs.equals(lhs))
			return false
		}
		assert(rhs.equals(lhs))
		return true
	}
}
