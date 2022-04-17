//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-28.
//

import Foundation
import ComposableArchitecture
import Wallet
import enum Zesame.KeyRestoration
import struct Zesame.Keystore
import typealias Zesame.PrivateKey

public enum WalletRestorerError: LocalizedError, Equatable {
	case invalidEncryptionPassword
	case walletRestoreFailed(reason: String)
	case decryptPrivateKeyFailed(reason: String)
	case keystoreExportFailure(reason: String)
	
	case internalError(error: String)
	public var errorDescription: String? {
		switch self {
		case .invalidEncryptionPassword:
			return "Encryption password does not meet minimum safety requirements. Try a longer and safer password."
		case let .internalError(underlyingError):
			return "Internal error, reason: \(underlyingError)"
		case let .walletRestoreFailed(underlyingError):
			return "Wallet import failed, reason: \(underlyingError)"
		case let .decryptPrivateKeyFailed(underlyingError):
			return "Decrypt private key failed, reason: \(underlyingError)"
		case let .keystoreExportFailure(underlyingError):
			return "Keystore export failed, reason: \(underlyingError)"
			
		}
	}
}

public struct RestoreWalletRequest {
	
	public enum Method {
		case privateKey(PrivateKey)
		case keystore(Keystore)
	}
	
	public let method: Method
	public let encryptionPassword: String
	public let name: String?
	public init(
		method: Method,
		encryptionPassword: String,
		name: String? = nil
	) {
		self.method = method
		self.encryptionPassword = encryptionPassword
		self.name = name
	}
}

public struct WalletRestorer {
	public typealias Restore = (RestoreWalletRequest) -> Effect<Wallet, WalletRestorerError>
	
	public var restore: Restore

	public init(
		restore: @escaping Restore
	) {
		self.restore = restore
	}
}
