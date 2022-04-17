//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import Common
import Combine
import ComposableArchitecture
import KeystoreGenerator
import KeystoreToFileWriter
import NamedKeystore
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
				// Generate
				.generate(request: request.keystoreGeneratorRequest)
				.mapError(WalletGenerator.Error.init(keyGenError:))
				.flatMap { namedKeystore in
					// Build
					builder.build(namedKeystore: namedKeystore)
						.mapError(WalletGenerator.Error.init(buildError:))
						.flatMap { wallet in
							keystoreToFileWriter
								// Persist
								.write(keystore: namedKeystore)
								.map { _ in wallet }
								.mapError(WalletGenerator.Error.init(writeError:))
						}
				}
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
		self = .failedToGenerate(keyGenError)
	}
	
	init(writeError: KeystoreToFileWriter.Error) {
		self = .failedToPersist(writeError)
	}
	
	init(buildError: WalletBuilder.Error) {
		self = .failedToBuildWallet(buildError)
	}
}
