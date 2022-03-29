//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-29.
//

import Foundation
import ComposableArchitecture
import Wallet
import WalletRestorer

import class Zesame.DefaultZilliqaService
import enum Zesame.Error
import enum Zesame.KeyRestoration
import protocol Zesame.ZilliqaService

#if DEBUG
public extension WalletRestorer {
	static func unsafeFast(
		zilliqaService: ZilliqaService = DefaultZilliqaService.default
	) -> Self {
		
		let unsafeWalletRestorer = Self(
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
		
		let warningString = "☣️"
		let separator = String(repeating: warningString, count: 20)
		print("\n")
		print(separator)
		print("\(warningString) Warning using unsafe wallet restorer \(warningString)")
		print(separator)
		print("\n")
		
		return unsafeWalletRestorer
	}
}


private extension RestoreWalletRequest {
	var keyRestoration: KeyRestoration {
		switch restorationMethod {
		case let .privateKey(privateKey):
			return .privateKey(
				privateKey,
				encryptBy: self.encryptionPassword,
				kdf: .pbkdf2,
				kdfParams: .unsafeFast
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


#else
private enum Inhabited {}
#endif
