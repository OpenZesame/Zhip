//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpWalletFeature
import ComposableArchitecture
import EnsurePrivacyFeature
import GenerateNewWalletFeature
import KeychainClient
import SwiftUI
import Wallet
import WalletGenerator

public enum NewWalletState: Equatable {
	
	case step1_EnsurePrivacy(EnsurePrivacyState)
	case step2_GenerateNewWallet(GenerateNewWalletState)
	case step3_BackUpWallet(BackUpWalletState)
	
	public init() {
		self = .step1_EnsurePrivacy(EnsurePrivacyState.init())
	}
}

public enum NewWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case ensurePrivacy(EnsurePrivacyAction)
	case generateNewWallet(GenerateNewWalletAction)
	case backUpWallet(BackUpWalletAction)
	
	case saveNewWalletInKeychain(Wallet)
}
public extension NewWalletAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpNewWallet
		case abortMightBeWatched
	}
}

public struct NewWalletEnvironment {
	public let walletGenerator: WalletGenerator
	public let keychainClient: KeychainClient
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		walletGenerator: WalletGenerator,
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.walletGenerator = walletGenerator
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
	}
}

public let newWalletReducer = Reducer<NewWalletState, NewWalletAction, NewWalletEnvironment>.combine(
	
	ensurePrivacyReducer.pullback(
		state: /NewWalletState.step1_EnsurePrivacy,
		action: /NewWalletAction.ensurePrivacy,
		environment: { _ in EnsurePrivacyEnvironment() }
	),
	
	generateNewWalletReducer.pullback(
		state: /NewWalletState.step2_GenerateNewWallet,
		action: /NewWalletAction.generateNewWallet,
		environment: {
			GenerateNewWalletEnvironment(
				walletGenerator: $0.walletGenerator,
				mainQueue: $0.mainQueue
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
		case .ensurePrivacy(.delegate(.abort)):
			return Effect(value: .delegate(.abortMightBeWatched))
		case .ensurePrivacy(.delegate(.proceed)):
			state = .step2_GenerateNewWallet(.init())
			return .none
		case .generateNewWallet(.delegate(.finishedGeneratingNewWallet(let wallet))):
			state = .step3_BackUpWallet(.init(wallet: wallet))
			return .none
		case .backUpWallet(.delegate(.finishedBackingUpWallet(let wallet))):
			return Effect(value: .saveNewWalletInKeychain(wallet))
		default: return .none
		}
	}
)

public struct NewWalletCoordinatorView: View {
	let store: Store<NewWalletState, NewWalletAction>
	public init(
		store: Store<NewWalletState, NewWalletAction>
	) {
		self.store = store
	}
}

public extension NewWalletCoordinatorView {
	var body: some View {
		
		SwitchStore(store) {
			CaseLet(
				state: /NewWalletState.step1_EnsurePrivacy,
				action: NewWalletAction.ensurePrivacy,
				then: EnsurePrivacyScreen.init(store:)
			)
			
			CaseLet(
				state: /NewWalletState.step2_GenerateNewWallet,
				action: NewWalletAction.generateNewWallet,
				then: GenerateNewWalletScreen.init(store:)
			)
			
			CaseLet(
				state: /NewWalletState.step3_BackUpWallet,
				action: NewWalletAction.backUpWallet,
				then: BackUpWalletCoordinatorView.init(store:)
			)
			
		}
	}
}
