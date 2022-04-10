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
import PasswordValidator
import SwiftUI
import Wallet
import WalletGenerator

public enum NewWallet {}

public extension NewWallet {
	
	enum Step: Equatable {
		
		case step1_EnsurePrivacy(EnsurePrivacyState)
		case step2_GenerateNewWallet(GenerateNewWalletState)
		case step3_BackUpWallet(BackUpWalletState)
		
		public init() {
			self = .step1_EnsurePrivacy(EnsurePrivacyState.init())
		}
	}
}

public extension NewWallet {
	typealias State = Step
}

public extension NewWallet {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case ensurePrivacy(EnsurePrivacyAction)
		case generateNewWallet(GenerateNewWalletAction)
		case backUpWallet(BackUpWalletAction)
	}
}
public extension NewWallet.Action {
	enum Delegate: Equatable {
		case finishedSettingUpNewWallet(Wallet)
		case abortMightBeWatched
	}
}

public extension NewWallet {
	struct Environment {
		
		public let keychainClient: KeychainClient
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let passwordValidator: PasswordValidator
		public let walletGenerator: WalletGenerator
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			keychainClient: KeychainClient,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			walletGenerator: WalletGenerator
		) {
			self.backgroundQueue = backgroundQueue
			self.keychainClient = keychainClient
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.walletGenerator = walletGenerator
		}
	}
}

public extension NewWallet {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		ensurePrivacyReducer.pullback(
			state: /State.step1_EnsurePrivacy,
			action: /NewWallet.Action.ensurePrivacy,
			environment: { _ in EnsurePrivacyEnvironment() }
		),
		
		generateNewWalletReducer.pullback(
			state: /State.step2_GenerateNewWallet,
			action: /NewWallet.Action.generateNewWallet,
			environment: {
				GenerateNewWalletEnvironment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletGenerator: $0.walletGenerator
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
				return Effect(value: .delegate(.finishedSettingUpNewWallet(wallet)))
			default: return .none
			}
		}
	)
}

public extension NewWallet {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}


public extension NewWallet.CoordinatorScreen {
	var body: some View {
		
		SwitchStore(store) {
			CaseLet(
				state: /NewWallet.State.step1_EnsurePrivacy,
				action: NewWallet.Action.ensurePrivacy,
				then: EnsurePrivacyScreen.init(store:)
			)
			
			CaseLet(
				state: /NewWallet.State.step2_GenerateNewWallet,
				action: NewWallet.Action.generateNewWallet,
				then: GenerateNewWalletScreen.init(store:)
			)
			
			CaseLet(
				state: /NewWallet.State.step3_BackUpWallet,
				action: NewWallet.Action.backUpWallet,
				then: BackUpWalletCoordinatorView.init(store:)
			)
			
		}
	}
}
