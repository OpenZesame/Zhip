//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-11.
//

import ComposableArchitecture
import Wallet

public struct WalletLoader {
	private let _loadWallet: LoadWallet
	public init(loadWallet: @escaping LoadWallet) {
		self._loadWallet = loadWallet
	}
}

public extension WalletLoader {
	enum Error: Swift.Error {
		case unknownError
	}
	
	func loadWallet() -> Effect<Wallet?, WalletLoader.Error> {
		_loadWallet()
	}
}

public extension WalletLoader {
	typealias LoadWallet = () -> Effect<Wallet?, WalletLoader.Error>
}
