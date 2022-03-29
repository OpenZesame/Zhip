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
	case walletImportFailed(reason: String)
	case decryptPrivateKeyFailed(reason: String)
	case keystoreExportFailure(reason: String)
	
	case internalError(error: String)
	public var errorDescription: String? {
		switch self {
		case .invalidEncryptionPassword:
			return "Encryption password does not meet minimum safety requirements. Try a longer and safer password."
		case let .internalError(underlyingError):
			return "Internal error, reason: \(underlyingError)"
		case let .walletImportFailed(underlyingError):
			return "Wallet import failed, reason: \(underlyingError)"
		case let .decryptPrivateKeyFailed(underlyingError):
			return "Decrypt private key failed, reason: \(underlyingError)"
		case let .keystoreExportFailure(underlyingError):
			return "Keystore export failed, reason: \(underlyingError)"
			
		}
	}
}

public struct RestoreWalletRequest {
	
	public enum RestorationMethod {
		case privateKey(PrivateKey)
		case keystore(Keystore)
	}
	
	public let restorationMethod: RestorationMethod
	public let encryptionPassword: String
	public let name: String?
	public init(
		restorationMethod: RestorationMethod,
		encryptionPassword: String,
		name: String? = nil
	) {
		self.restorationMethod = restorationMethod
		self.encryptionPassword = encryptionPassword
		self.name = name
	}
}

public struct WalletRestorer {
	public typealias RestoreWallet = (RestoreWalletRequest) -> Effect<Wallet, WalletRestorerError>
	
	public var restore: RestoreWallet

	public init(
		restore: @escaping RestoreWallet
	) {
		self.restore = restore
	}
}
