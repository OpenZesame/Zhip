//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import PasswordValidator
import RestoreWalletMethodChoiceFeature
import SwiftUI
import Wallet
import WalletRestorer

public enum RestoreWallet {}

public extension RestoreWallet {
	
	enum Step: Equatable {
		
		case step1_EnsurePrivacy(EnsurePrivacy.State)
		case step2_RestoreWallet(RestoreWalletMethodChoiceState)
		
		public init() {
			self = .step1_EnsurePrivacy(.init())
		}
	}
}

public extension RestoreWallet {
	typealias State = Step
}


public extension RestoreWallet {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case ensurePrivacy(EnsurePrivacy.Action)
		case restoreUsingMethod(RestoreWalletMethodChoiceAction)
		
	}
}
public extension RestoreWallet.Action {
	enum Delegate: Equatable {
		case finishedRestoringWallet(Wallet)
		case abortMightBeWatched
	}
}

public extension RestoreWallet {
	struct Environment {
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let passwordValidator: PasswordValidator
		public let walletRestorer: WalletRestorer
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			walletRestorer: WalletRestorer
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.walletRestorer = walletRestorer
		}
	}
}

public extension RestoreWallet {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		EnsurePrivacy.reducer.pullback(
			state: /State.step1_EnsurePrivacy,
			action: /RestoreWallet.Action.ensurePrivacy,
			environment: { _ in
				EnsurePrivacy.Environment()
			}
		),
		
		restoreWalletMethodReducer.pullback(
			state: /State.step2_RestoreWallet,
			action: /RestoreWallet.Action.restoreUsingMethod,
			environment: {
				RestoreWalletMethodChoiceEnvironment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletRestorer: $0.walletRestorer
				)
			}
		),
		
		Reducer { state, action, environment in
			switch action {
			case .ensurePrivacy(.delegate(.abort)):
				return Effect(value: .delegate(.abortMightBeWatched))
			case .ensurePrivacy(.delegate(.proceed)):
				state = .step2_RestoreWallet(.init())
				return .none
			case .ensurePrivacy(_):
				return .none
			case let .restoreUsingMethod(.delegate(.finishedRestoring(wallet))):
				return Effect(value: .delegate(.finishedRestoringWallet(wallet)))
			case .restoreUsingMethod(_):
				return .none
			case .delegate(_):
				return .none
			}
		}
	)
}

public extension RestoreWallet {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension RestoreWallet.CoordinatorScreen {
	var body: some View {
		SwitchStore(store) {
			CaseLet(
				state: /RestoreWallet.State.step1_EnsurePrivacy,
				action: RestoreWallet.Action.ensurePrivacy,
				then: EnsurePrivacy.Screen.init(store:)
			)
			
			CaseLet(
				state: /RestoreWallet.State.step2_RestoreWallet,
				action: RestoreWallet.Action.restoreUsingMethod,
				then: RestoreWalletScreen.init(store:)
			)
			
			
		}
	}
}
