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
		
		case step1_EnsurePrivacy(EnsurePrivacy.State)
		case step2_GenerateNewWallet(GenerateNewWallet.State)
		case step3_BackUpWallet(BackUpWallet.Coordinator.State)
		
		public init() {
			self = .step1_EnsurePrivacy(.init())
		}
	}
}

public extension NewWallet {
	typealias State = Step
}

public extension NewWallet {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case ensurePrivacy(EnsurePrivacy.Action)
		case generateNewWallet(GenerateNewWallet.Action)
		case backUpWallet(BackUpWallet.Coordinator.Action)
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
		
		EnsurePrivacy.reducer.pullback(
			state: /State.step1_EnsurePrivacy,
			action: /NewWallet.Action.ensurePrivacy,
			environment: { _ in EnsurePrivacy.Environment() }
		),
		
		GenerateNewWallet.reducer.pullback(
			state: /State.step2_GenerateNewWallet,
			action: /NewWallet.Action.generateNewWallet,
			environment: {
				GenerateNewWallet.Environment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletGenerator: $0.walletGenerator
				)
			}
		),
		
		BackUpWallet.Coordinator.reducer.pullback(
			state: /State.step3_BackUpWallet,
			action: /NewWallet.Action.backUpWallet,
			environment: {
				BackUpWallet.Environment(
					backgroundQueue: $0.backgroundQueue,
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
			case .generateNewWallet(.delegate(.finished(let wallet))):
				state = .step3_BackUpWallet(.fromOnboarding(wallet: wallet))
				return .none
			case .backUpWallet(.delegate(.finished(let wallet))):
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
				then: EnsurePrivacy.Screen.init(store:)
			)
			
			CaseLet(
				state: /NewWallet.State.step2_GenerateNewWallet,
				action: NewWallet.Action.generateNewWallet,
				then: GenerateNewWallet.Screen.init(store:)
			)
			
			CaseLet(
				state: /NewWallet.State.step3_BackUpWallet,
				action: NewWallet.Action.backUpWallet,
				then: BackUpWallet.Coordinator.View.init(store:)
			)
			
		}
	}
}
