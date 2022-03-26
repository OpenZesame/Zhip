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
import RestoreWalletFeature
import SwiftUI
import Wallet
import WalletGenerator

public struct SetupWalletState: Equatable {
	public enum Step: Equatable {
		case step1_NewWalletOrRestore
		
		case step2a_NewWallet
		case step2b_RestoreWallet
	}

	public var newWalletOrRestore: NewWalletOrRestoreState

	public var newWallet: NewWalletState
	public var restoreWallet: RestoreWalletState
	
	
	public var alert: AlertState<SetupWalletAction>?
	public var step: Step
	
	public init(
		step: Step = .step1_NewWalletOrRestore,
		newWalletOrRestore: NewWalletOrRestoreState = .init(),
		newWallet: NewWalletState = .init(),
		restoreWallet: RestoreWalletState = .init(),
		alert: AlertState<SetupWalletAction>? = nil
	) {
		self.step = step
		self.newWalletOrRestore = newWalletOrRestore
		self.newWallet = newWallet
		self.restoreWallet = restoreWallet
		self.alert = alert
	}
}

public enum SetupWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case newWalletOrRestore(NewWalletOrRestoreAction)
	
	case newWallet(NewWalletAction)
	case restoreWallet(RestoreWalletAction)
	
	case abortDueToMightBeWatched
	case saveNewWalletInKeychain(Wallet)
	case saveNewWalletInKeychainResult(Result<Wallet, KeychainClient.Error>)
	
	case alertDismissed
}
public extension SetupWalletAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpWallet(Wallet)
	}
}

public struct SetupWalletEnvironment {
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

public let setupWalletReducer = Reducer<SetupWalletState, SetupWalletAction, SetupWalletEnvironment>.combine(
	
	newWalletOrRestoreReducer.pullback(
		state: \.newWalletOrRestore,
		action: /SetupWalletAction.newWalletOrRestore,
		environment: { _ in
			NewWalletOrRestoreEnvironment()
		}
	),
		
	newWalletReducer.pullback(
		state: \.newWallet,
		action: /SetupWalletAction.newWallet,
		environment: {
			NewWalletEnvironment(
				walletGenerator: $0.walletGenerator,
				keychainClient: $0.keychainClient,
				mainQueue: $0.mainQueue
			)
		}
	),
	
	restoreWalletReducer.pullback(
		state: \.restoreWallet,
		action: /SetupWalletAction.restoreWallet,
		environment: { _ in RestoreWalletEnvironment() }
	),
		
	Reducer<SetupWalletState, SetupWalletAction, SetupWalletEnvironment> { state, action, environment in
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
				.catchToEffect(SetupWalletAction.saveNewWalletInKeychainResult)
	
		case let .saveNewWalletInKeychainResult(.failure(error)):
			state.alert = .init(title: TextState.init("Failed to save wallet in keychain, do you have a passcode setup on your Apple device? It is required to use Zhip. Underlying error: \(String(describing: error))"))
			return .none
			
		case let .saveNewWalletInKeychainResult(.success(wallet)):
			return Effect(value: .delegate(.finishedSettingUpWallet(wallet)))
		
		default:
			return .none
		}
	}
)

public struct SetupWalletCoordinatorView: View {
	let store: Store<SetupWalletState, SetupWalletAction>
	public init(store: Store<SetupWalletState, SetupWalletAction>) {
		self.store = store
	}
}
public extension SetupWalletCoordinatorView {
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
							action: SetupWalletAction.newWalletOrRestore
						)
					)
				case .step2a_NewWallet:
					NewWalletCoordinatorView(
						store: store.scope(
							state: \.newWallet,
							action: SetupWalletAction.newWallet
						)
					)
				case .step2b_RestoreWallet:
					RestoreWalletCoordinatorView(
						store: store.scope(
							state: \.restoreWallet,
							action: SetupWalletAction.restoreWallet
						)
					)
				}
			}
			.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
		}
		
	}
}

private extension SetupWalletCoordinatorView {
	struct ViewState: Equatable {
		let step: SetupWalletState.Step
		
		init(state: SetupWalletState) {
			self.step = state.step
		}
	}
}
