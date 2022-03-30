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
	
	/// Generates a keystore using a UNSAFE key derivation function (KDF) algorithm,
	/// with UNSAFE parameters.
	///
	/// Example keystore using `pbkdf2` and encryption password `apabanan`:
	///
	///		{
	///			"version" : 3,
	///			"id" : "9F96BFFE-4213-4F21-9FE7-2798B67F2167",
	///			"crypto" : {
	///				"ciphertext" : "3daf4cfd5b469f3eb383b7269ad678e46f4da9cf0c1efed88c86eafc1d2a215e",
	///				"cipherparams" : {
	///					"iv" : "26d5d4e274634c1595db37786d431f9f"
	///				},
	///				"kdf" : "pbkdf2",
	///				"kdfparams" : {
	///					"r" : 8,
	///					"p" : 1,
	///					"n" : 1,
	///					"c" : 1,
	///					"dklen" : 32,
	///					"salt" : "074bfeeea625439bd10c7045b60d5653ce1196a99226d8bd187e821703e25cc1"
	///				},
	///				"mac" : "b9f5766a815822ed0877e2cef2037e6abc9633ee590a24240d606321c31588bc",
	///				"cipher" : "aes-128-ctr"
	///			},
	///			"address" : "Be1d30e0268F9417560CeBC11E2959B2FC098922"
	///		}
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
