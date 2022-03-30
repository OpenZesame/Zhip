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
	
	/// Generates a keystore using a safe key derivation function (KDF) algorithm,
	/// with safe parameters.
	///
	/// Example keystore using `scrypt` and encryption password `12345678`:
	///
	///		{
	///		  "version" : 3,
	///		  "id" : "1046002B-A368-4140-9BD9-6D8857D70240",
	///		  "crypto" : {
	///			"ciphertext" : "d4a871a14960aaa22f5224d74ae1732cd2efb45b21c65b62416879a5b6682a17",
	///			"cipherparams" : {
	///			  "iv" : "633a79bdecbe4fb51529a9dddea22e71"
	///			},
	///			"kdf" : "scrypt",
	///			"kdfparams" : {
	///			  "r" : 8,
	///			  "p" : 1,
	///			  "n" : 8192,
	///			  "c" : 262144,
	///			  "dklen" : 32,
	///			  "salt" : "d92a124eaeaebce41f5ceb8d6aa4240f3e8c1e54335849ca3d53b5272fde9722"
	///			},
	///			"mac" : "4e812c5b688f2af14e476efae641ac1a1b96d3e09cbd1a4a1cae3e21de67a0e4",
	///			"cipher" : "aes-128-ctr"
	///		  },
	///		  "address" : "1D642D099D299e092e32221F8FAd924B21ba447E"
	///		}
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
			self = .internalError(error: String(describing: anyError))
		}
		
	}
}
