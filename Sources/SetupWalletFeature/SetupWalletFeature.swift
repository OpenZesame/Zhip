//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import NewPINFeature
import NewWalletFeature
import NewWalletOrRestoreFeature
import RestoreWalletFeature
import SwiftUI

public struct SetupWalletState: Equatable {
	public enum Step: Equatable {
		case step1_NewWalletOrRestore
		
		case step2a_NewWallet
		case step2b_RestoreWallet
		
		case step3_NewPin
	}

	public var newWalletOrRestore: NewWalletOrRestoreState

	public var newWallet: NewWalletState
	public var restoreWallet: RestoreWalletState
	
	public var newPIN: NewPINState
	
	public var step: Step
	
	public init(
		step: Step = .step1_NewWalletOrRestore,
		newWalletOrRestore: NewWalletOrRestoreState = .init(),
		newWallet: NewWalletState = .init(),
		restoreWallet: RestoreWalletState = .init(),
		newPIN: NewPINState = .init()
	) {
		self.step = step
		self.newWalletOrRestore = newWalletOrRestore
		self.newWallet = newWallet
		self.restoreWallet = restoreWallet
		self.newPIN = newPIN
	}
}

public enum SetupWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case newWalletOrRestore(NewWalletOrRestoreAction)
	
	case newWallet(NewWalletAction)
	case restoreWallet(RestoreWalletAction)
	
	case newPIN(NewPINAction)
}
public extension SetupWalletAction {
	enum DelegateAction {
		case finishedSettingUpWallet
	}
}

public struct SetupWalletEnvironment {
	public init() {}
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
		environment: { _ in NewWalletEnvironment() }
	),
	
	restoreWalletReducer.pullback(
		state: \.restoreWallet,
		action: /SetupWalletAction.restoreWallet,
		environment: { _ in RestoreWalletEnvironment() }
	),
	
	newPINReducer.pullback(
		state: \.newPIN,
		action: /SetupWalletAction.newPIN,
		environment: { _ in NewPINEnvironment() }
	),
	
	Reducer<SetupWalletState, SetupWalletAction, SetupWalletEnvironment> { state, action, environment in
		switch action {
		case .newWalletOrRestore(.delegate(.generateNewWallet)):
			state.step = .step2a_NewWallet
			return .none
		case .newWalletOrRestore(.delegate(.restoreWallet)):
			state.step = .step2b_RestoreWallet
			return .none
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
				default:
					Text("Unhandled SetupWallet step: \(String(describing: viewStore.step))")
				}
			}
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
