//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-16.
//

import Common
import Combine
import ComposableArchitecture
import Foundation
import KeystoreFromFileReader
import NamedKeystore
import WalletBuilder
import Wallet

public extension WalletLoader {
	static func live(
		reader: KeystoreFromFileReader,
		builder: WalletBuilder
	) -> Self {
		Self(loadWallet: {
			reader.read()
				.mapError(WalletLoader.Error.init(readError:))
				.flatMap(
					ifPresent: builder.build(namedKeystore:),
					mapError: WalletLoader.Error.init(builderError:)
				)
				.eraseToEffect()
		})
	}
}

private extension WalletLoader.Error {
	init(builderError: WalletBuilder.Error) {
		fatalError()
	}
}

private extension WalletLoader.Error {
	init(readError: KeystoreFromFileReader.Error) {
		fatalError()
	}
}
