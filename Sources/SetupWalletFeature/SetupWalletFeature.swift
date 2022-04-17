//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import KeychainClient
import NewWalletFeature
import NewWalletOrRestoreFeature
import PasswordValidator
import RestoreWalletFeature
import SwiftUI
import Wallet
import WalletGenerator
import WalletRestorer

// MARK: - SetupWallet
// MARK: -

/// Setup wallet flow, guides the user through either generating a new wallet,
/// or through restoration of an existing wallet from backup.
public enum SetupWallet {}

// MARK: - Step
// MARK: -
public extension SetupWallet {
	/// Components of the setup wallet flow, can either be a single screen or
	/// a subflow consisting of multiple screens, or subsubflows.
	enum Step: Equatable {
		case step1_NewWalletOrRestore
		
		case step2a_NewWallet
		case step2b_RestoreWallet
	}
	
}

// MARK: - State
// MARK: -
public extension SetupWallet {
	
	/// State of the setup wallet flow
	struct State: Equatable {
		
		public var newWalletOrRestore: NewWalletOrRestore.State
		
		public var newWallet: NewWallet.State
		public var restoreWallet: RestoreWallet.State
		
		
		public var alert: AlertState<SetupWallet.Action>?
		public var step: Step
		
		public init(
			step: Step = .step1_NewWalletOrRestore,
			newWalletOrRestore: NewWalletOrRestore.State = .init(),
			newWallet: NewWallet.State = .init(),
			restoreWallet: RestoreWallet.State = .init(),
			alert: AlertState<SetupWallet.Action>? = nil
		) {
			self.step = step
			self.newWalletOrRestore = newWalletOrRestore
			self.newWallet = newWallet
			self.restoreWallet = restoreWallet
			self.alert = alert
		}
	}
}

// MARK: - Action
// MARK: -
public extension SetupWallet {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case newWalletOrRestore(NewWalletOrRestore.Action)
		
		case newWallet(NewWallet.Action)
		case restoreWallet(RestoreWallet.Action)
		
		case abortDueToMightBeWatched
		
		case alertDismissed
	}
}

public extension SetupWallet.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}


// MARK: - Environment
// MARK: -
public extension SetupWallet {
	struct Environment {
		
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let keychainClient: KeychainClient
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let passwordValidator: PasswordValidator
		public let walletGenerator: WalletGenerator
		public let walletRestorer: WalletRestorer
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			keychainClient: KeychainClient,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			walletGenerator: WalletGenerator,
			walletRestorer: WalletRestorer
		) {
			self.backgroundQueue = backgroundQueue
			self.keychainClient = keychainClient
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.walletGenerator = walletGenerator
			self.walletRestorer = walletRestorer
		}
	}
}


// MARK: - Reducer
// MARK: -
public extension SetupWallet {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		NewWalletOrRestore.reducer.pullback(
			state: \.newWalletOrRestore,
			action: /SetupWallet.Action.newWalletOrRestore,
			environment: { _ in
				NewWalletOrRestore.Environment()
			}
		),
		
		NewWallet.reducer.pullback(
			state: \.newWallet,
			action: /SetupWallet.Action.newWallet,
			environment: {
				NewWallet.Environment(
					backgroundQueue: $0.backgroundQueue,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletGenerator: $0.walletGenerator
				)
			}
		),
		
		RestoreWallet.reducer.pullback(
			state: \.restoreWallet,
			action: /SetupWallet.Action.restoreWallet,
			environment: {
				RestoreWallet.Environment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletRestorer: $0.walletRestorer
				)
			}
		),
		
		Reducer<State, Action, Environment> { state, action, environment in
			switch action {
			case .newWalletOrRestore(.delegate(.generateNewWallet)):
				state.step = .step2a_NewWallet
				return .none
			case .newWalletOrRestore(.delegate(.restoreWallet)):
				state.step = .step2b_RestoreWallet
				return .none
				
			case let .newWallet(.delegate(.finishedSettingUpNewWallet(wallet))):
				// FIXME: assert that keystore of wallet is saved in keychain!
				return Effect(value: .delegate(.finished(wallet)))
				
			case .newWallet(.delegate(.abortMightBeWatched)):
				return Effect(value: .abortDueToMightBeWatched)
				
			case let .restoreWallet(.delegate(.finishedRestoringWallet(wallet))):
				// FIXME: assert that keystore of wallet is saved in keychain!
				return Effect(value: .delegate(.finished(wallet)))
				
			case .restoreWallet(.delegate(.abortMightBeWatched)):
				return Effect(value: .abortDueToMightBeWatched)
				
			case .abortDueToMightBeWatched:
				state.step = .step1_NewWalletOrRestore
				return .none
				
			case .alertDismissed:
				state.alert = nil
				return .none
				
//			case let .saveNewWalletInKeychain(wallet):
//				return environment.walletSaver
//					.saveWallet(wallet)
//					.catchToEffect(SetupWallet.Action.saveNewWalletInKeychainResult)
//
//			case let .saveNewWalletInKeychainResult(.failure(error)):
//				state.alert = .init(title: TextState.init("Failed to save wallet in keychain, do you have a passcode setup on your Apple device? It is required to use Zhip. Underlying error: \(String(describing: error))"))
//				return .none
//
//			case let .saveNewWalletInKeychainResult(.success(wallet)):
//				return Effect(value: .delegate(.finished(wallet)))
				
			default:
				return .none
			}
		}
	)
}

public extension SetupWallet {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}
public extension SetupWallet.CoordinatorScreen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Group {
				switch viewStore.step {
				case .step1_NewWalletOrRestore:
					NewWalletOrRestore.Screen(
						store: store.scope(
							state: \.newWalletOrRestore,
							action: SetupWallet.Action.newWalletOrRestore
						)
					)
				case .step2a_NewWallet:
					NewWallet.CoordinatorScreen(
						store: store.scope(
							state: \.newWallet,
							action: SetupWallet.Action.newWallet
						)
					)
				case .step2b_RestoreWallet:
					RestoreWallet.CoordinatorScreen(
						store: store.scope(
							state: \.restoreWallet,
							action: SetupWallet.Action.restoreWallet
						)
					)
				}
			}
			.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
		}
		
	}
}

private extension SetupWallet.CoordinatorScreen {
	struct ViewState: Equatable {
		let step: SetupWallet.Step
		
		init(state: SetupWallet.State) {
			self.step = state.step
		}
	}
}
