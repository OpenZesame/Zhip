//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import ComposableArchitecture
import KeystoreRestorer
import KeystoreToFileWriter
import Wallet
import WalletBuilder

public extension WalletRestorer {
	static func live(
		keystoreRestorer: KeystoreRestorer,
		keystoreToFileWriter: KeystoreToFileWriter,
		walletBuilder builder: WalletBuilder
	) -> Self {
		Self(restore: { request in
		
			keystoreRestorer
				// Restore
				.restore(request: request.keystoreRestorerRequest)
				.mapError(WalletRestorer.Error.init(restoreError:))
				.flatMap { namedKeystore in
					// Build
					builder.build(namedKeystore: namedKeystore)
						.mapError(WalletRestorer.Error.init(buildError:))
						.flatMap { wallet in
							keystoreToFileWriter
								// Persist
								.write(keystore: namedKeystore)
								.map { _ in wallet }
								.mapError(WalletRestorer.Error.init(writeError:))
						}
				}
				.eraseToEffect()
		})
	}
}

private extension WalletRestorer.Request {
	var keystoreRestorerRequest: KeystoreRestorer.Request {
		.init(
			method: method.keystoreRestorationMethod,
			password: password,
			name: name
		)
	}
}

private extension WalletRestorer.Request.Method {
	var keystoreRestorationMethod: KeystoreRestorer.Request.Method {
		switch self {
		case .keystore(let ks):
			return .restoreFromKeystore(ks)
		case .privateKey(let pk):
			return .restoreFromPrivateKey(pk)
		}
	}
}

private extension WalletRestorer.Error {
	
	init(restoreError: KeystoreRestorer.Error) {
		self = .failedToRestore(restoreError)
	}
	
	init(writeError: KeystoreToFileWriter.Error) {
		self = .failedToPersist(writeError)
	}
	
	init(buildError: WalletBuilder.Error) {
		self = .failedToBuildWallet(buildError)
	}
}
