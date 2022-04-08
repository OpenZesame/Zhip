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
		
		public var newWalletOrRestore: NewWalletOrRestoreState
		
		public var newWallet: NewWalletState
		public var restoreWallet: RestoreWalletState
		
		
		public var alert: AlertState<SetupWallet.Action>?
		public var step: Step
		
		public init(
			step: Step = .step1_NewWalletOrRestore,
			newWalletOrRestore: NewWalletOrRestoreState = .init(),
			newWallet: NewWalletState = .init(),
			restoreWallet: RestoreWalletState = .init(),
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
		
		case newWalletOrRestore(NewWalletOrRestoreAction)
		
		case newWallet(NewWalletAction)
		case restoreWallet(RestoreWalletAction)
		
		case abortDueToMightBeWatched
		case saveNewWalletInKeychain(Wallet)
		case saveNewWalletInKeychainResult(Result<Wallet, KeychainClient.Error>)
		
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
		
		newWalletOrRestoreReducer.pullback(
			state: \.newWalletOrRestore,
			action: /SetupWallet.Action.newWalletOrRestore,
			environment: { _ in
				NewWalletOrRestoreEnvironment()
			}
		),
		
		newWalletReducer.pullback(
			state: \.newWallet,
			action: /SetupWallet.Action.newWallet,
			environment: {
				NewWalletEnvironment(
					backgroundQueue: $0.backgroundQueue,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletGenerator: $0.walletGenerator
				)
			}
		),
		
		restoreWalletReducer.pullback(
			state: \.restoreWallet,
			action: /SetupWallet.Action.restoreWallet,
			environment: {
				RestoreWalletEnvironment(
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
				
			case let  .newWallet(.delegate(.finishedSettingUpNewWallet(wallet))):
				return Effect(value: .saveNewWalletInKeychain(wallet))
				
			case .newWallet(.delegate(.abortMightBeWatched)):
				return Effect(value: .abortDueToMightBeWatched)
				
			case let .restoreWallet(.delegate(.finishedRestoringWallet(wallet))):
				return Effect(value: .saveNewWalletInKeychain(wallet))
				
			case .restoreWallet(.delegate(.abortMightBeWatched)):
				return Effect(value: .abortDueToMightBeWatched)
				
			case .abortDueToMightBeWatched:
				state.step = .step1_NewWalletOrRestore
				return .none
				
			case .alertDismissed:
				state.alert = nil
				return .none
				
			case let .saveNewWalletInKeychain(wallet):
				return environment.keychainClient
					.saveWallet(wallet)
					.catchToEffect(SetupWallet.Action.saveNewWalletInKeychainResult)
				
			case let .saveNewWalletInKeychainResult(.failure(error)):
				state.alert = .init(title: TextState.init("Failed to save wallet in keychain, do you have a passcode setup on your Apple device? It is required to use Zhip. Underlying error: \(String(describing: error))"))
				return .none
				
			case let .saveNewWalletInKeychainResult(.success(wallet)):
				return Effect(value: .delegate(.finished(wallet)))
				
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
					NewWalletOrRestoreScreen(
						store: store.scope(
							state: \.newWalletOrRestore,
							action: SetupWallet.Action.newWalletOrRestore
						)
					)
				case .step2a_NewWallet:
					NewWalletCoordinatorView(
						store: store.scope(
							state: \.newWallet,
							action: SetupWallet.Action.newWallet
						)
					)
				case .step2b_RestoreWallet:
					RestoreWalletCoordinatorView(
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
