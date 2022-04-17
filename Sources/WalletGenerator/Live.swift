//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import Common
import ComposableArchitecture
import KeystoreGenerator
import KeystoreToFileWriter
import Password
import Wallet
import WalletBuilder

public extension WalletGenerator {
	static func live(
		keystoreGenerator: KeystoreGenerator,
		keystoreToFileWriter: KeystoreToFileWriter,
		walletBuilder builder: WalletBuilder
	) -> Self {
		Self(generate: { request in
			
			keystoreGenerator
				.generate(request: request.keystoreGeneratorRequest)
				.mapError(WalletGenerator.Error.init(keyGenError:))
				.flatMap(
					ifPresent: builder.build(namedKeystore:),
					mapError: WalletGenerator.Error.init(builderError:)
				)
				.eraseToEffect()
		})
	}
}

private extension WalletGenerator.Request {
	var keystoreGeneratorRequest: KeystoreGenerator.Request {
		.init(password: self.password, name: self.name)
	}
}

private extension WalletGenerator.Error {
	init(keyGenError: KeystoreGenerator.Error) {
		fatalError()
	}
	
	init(builderError: WalletBuilder.Error) {
		fatalError()
	}
}
