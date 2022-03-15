//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-15.
//

import ComposableArchitecture
import Wallet
import WalletGenerator
import Zesame

#if DEBUG
public extension WalletGenerator {
	static func unsafeFast(
		zilliqaService: ZilliqaService = DefaultZilliqaService.default
	) -> Self {
		
		let unsafeWalletGenerator = Self(
			generate: { generateWalletRequest in
				generateWalletRequest.encryptionPassword.isEmpty
				? Effect(error: .invalidEncryptionPassword)
				: Effect.task {
					try await zilliqaService.createNewWallet(
						encryptionPassword: generateWalletRequest.encryptionPassword,
						kdf: .pbkdf2, // not as safe as `Scrypt`
						kdfParams: .unsafeFast
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
		
		let warningString = "☣️"
		let separator = String(repeating: warningString, count: 20)
		print("\n")
		print(separator)
		print("\(warningString) Warning using unsafe wallet generator \(warningString)")
		print(separator)
		print("\n")
		
		return unsafeWalletGenerator
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
			self = .internalError(error: String(describing: anyError))
		}
		
	}
}

#else
private enum Inhabited {}
#endif
