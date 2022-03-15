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
					Wallet.init(
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
	init(_ error: Swift.Error) {
		fatalError()
	}
}

//extension AuthenticationClient {
//  public static let live = AuthenticationClient(
//	login: { request in
//	  (request.email.contains("@") && request.password == "password"
//		? Effect(value: .init(token: "deadbeef", twoFactorRequired: request.email.contains("2fa")))
//		: Effect(error: .invalidUserPassword))
//		.delay(for: 1, scheduler: queue)
//		.eraseToEffect()
//	},
//	twoFactor: { request in
//	  (request.token != "deadbeef"
//		? Effect(error: .invalidIntermediateToken)
//		: request.code != "1234"
//		  ? Effect(error: .invalidTwoFactor)
//		  : Effect(value: .init(token: "deadbeefdeadbeef", twoFactorRequired: false)))
//		.delay(for: 1, scheduler: queue)
//		.eraseToEffect()
//	}
//  )
//}

private let queue = DispatchQueue(label: "WalletGenerator")
