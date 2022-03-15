//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-15.
//

import ComposableArchitecture
import Foundation
import WalletGenerator
import Wallet
import Zesame

public extension WalletGenerator {
	static func live(
		zilliqaService: ZilliqaService = DefaultZilliqaService.default
	) -> Self {
		Self(
			generate: { generateWalletRequest in
				generateWalletRequest.encryptionPassword.isEmpty
				? Effect(error: .invalidEncryptionPassword)
				: Effect.task {
					try await zilliqaService.createNewWallet(
						encryptionPassword: generateWalletRequest.encryptionPassword,
						kdf: .default,
						kdfParams: .default
					)
				}
				.mapError(WalletGeneratorError.init)
				.map {
					Wallet(
						name: generateWalletRequest.name,
						wallet: $0,
						origin: .generatedByThisApp
					)
				}
				.eraseToEffect()
			}
		)
	}
}

private extension WalletGeneratorError {
	init(_ anyError: Swift.Error) {
		if
			let zesameError = anyError as? Zesame.Error,
			case .keystorePasswordTooShort = zesameError
		{
			self = .invalidEncryptionPassword
		} else {
			self = .internalError(anyError)
		}
		
	}
}
