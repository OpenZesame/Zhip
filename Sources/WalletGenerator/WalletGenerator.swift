//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-15.
//

import Foundation
import ComposableArchitecture
import Wallet

public enum WalletGeneratorError: LocalizedError {
	case invalidEncryptionPassword
	public var errorDescription: String? {
		switch self {
		case .invalidEncryptionPassword:
			return "Encryption password does not meet minimum safety requirements. Try a longer and safer password."
		}
	}
}

public struct GenerateWalletRequest: Equatable {
	public let encryptionPassword: String
	public let name: String?
	public init(
		encryptionPassword: String,
		name: String? = nil
	){
		self.encryptionPassword = encryptionPassword
		self.name = name
	}
}

public struct WalletGenerator {
	public typealias GenerateWallet = (GenerateWalletRequest) -> Effect<Wallet, WalletGeneratorError>
	
	public var generate: GenerateWallet

	public init(
		generate: @escaping GenerateWallet
	) {
		self.generate = generate
	}
}


