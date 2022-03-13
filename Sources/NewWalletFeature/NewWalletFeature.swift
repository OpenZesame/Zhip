//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import GenerateNewWalletFeature
import BackUpWalletFeature

public struct NewWalletState: Equatable {
	
	public var ensurePrivacy: EnsurePrivacyState
	public var generateNewWallet: GenerateNewWalletState
	public var backUpWallet: BackUpWalletState
	
	public init(
		ensurePrivacy: EnsurePrivacyState = .init(),
		generateNewWallet: GenerateNewWalletState = .init(),
		backUpWallet: BackUpWalletState = .init()
	) {
		self.ensurePrivacy = ensurePrivacy
		self.generateNewWallet = generateNewWallet
		self.backUpWallet = backUpWallet
	}
}

public enum NewWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case ensurePrivacy(EnsurePrivacyAction)
}
public extension NewWalletAction {
	enum DelegateAction: Equatable {
		case finishedGeneratingNewWallet
	}
}

public struct NewWalletEnvironment {
	public init() {}
}

public let newWalletReducer = Reducer<NewWalletState, NewWalletAction, NewWalletEnvironment>.combine(
	
	ensurePrivacyReducer.pullback(
		state: \.ensurePrivacy,
		action: /NewWalletAction.ensurePrivacy,
		environment: { _ in EnsurePrivacyEnvironment() }
	),
	
	Reducer { state, action, environment in
		switch action {
		case .ensurePrivacy(.delegate(.abort)):
			return .none
		case .ensurePrivacy(.delegate(.proceed)):
			return .none
		default: return .none
		}
	}
)
