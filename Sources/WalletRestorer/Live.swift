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
		walletBuilder: WalletBuilder
	) -> Self {
		Self(restore: { request -> Effect<Wallet, WalletRestorerError> in
//			keystoreRestorer.restore(request).flatMap { keystore in
//				keystoreToFileWriter.write(keystore).flatMap { _ in
//					walletBuilder.build(keystore)
//				}
//			}
			fatalError()
		})
	}
}
