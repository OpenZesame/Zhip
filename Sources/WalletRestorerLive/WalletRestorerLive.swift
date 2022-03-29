//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-28.
//

import Foundation
import ComposableArchitecture
import Wallet
import WalletRestorer

import class Zesame.DefaultZilliqaService
import enum Zesame.Error
import enum Zesame.KeyRestoration
import protocol Zesame.ZilliqaService

public extension WalletRestorer {
	static func live(
		zilliqaService: ZilliqaService = DefaultZilliqaService.default
	) -> Self {
		Self(
			restore: { restoreWalletRequest in
				restoreWalletRequest.encryptionPassword.isEmpty
				? Effect(error: .invalidEncryptionPassword)
				: Effect.task {
					let restoration = restoreWalletRequest.keyRestoration
					let origin: Wallet.Origin
					switch restoration {
					case .keystore: origin = .importedKeystore
					case .privateKey: origin = .importedPrivateKey
					}
					
					let restored = try await zilliqaService.restoreWallet(from: restoration)
					
					return Wallet(
						name: restoreWalletRequest.name,
						wallet: restored,
						origin: origin
					)
				}
				.mapError(WalletRestorerError.init)
				.eraseToEffect()
			}
		)
	}
}

private extension RestoreWalletRequest {
	var keyRestoration: KeyRestoration {
		switch restorationMethod {
		case let .privateKey(privateKey):
			return .privateKey(
				privateKey,
				encryptBy: self.encryptionPassword,
				kdf: .scrypt,
				kdfParams: .default
			)
		case let .keystore(keyStore):
			return .keystore(keyStore, password: self.encryptionPassword)
		}
	}
}


private extension WalletRestorerError {
	init(_ anyError: Swift.Error) {
		if let zesameError = anyError as? Zesame.Error {
			switch zesameError {
			case .keystorePasswordTooShort:
				self = .invalidEncryptionPassword
			case let .walletImport(walletImportError):
//				switch walletImportError {
//				case .badAddress:
//
//				case .badPrivateKeyHex:
//				case .jsonStringDecoding:
//				case let .jsonDecoding(decodingError):
//				case .incorrectPassword:
//				case let .keystoreError(keyStoreFailure):
//				}
				self = .walletImportFailed(reason: walletImportError.localizedDescription)
			case let .keystoreExport(keystoreExportFailure):
				self = .keystoreExportFailure(reason: keystoreExportFailure.localizedDescription)
			case let .decryptPrivateKey(decryptPrivateKeyFailure):
				self = .decryptPrivateKeyFailed(reason: decryptPrivateKeyFailure.localizedDescription)
			case .api:
				self = .internalError(error: String(describing: anyError))
			}
		} else {
			self = .internalError(error: String(describing: anyError))
		}
	}
}
