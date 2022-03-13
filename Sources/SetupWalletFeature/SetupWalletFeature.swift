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

	public var newWalletOrRestore: NewWalletOrRestoreState

	public var newWallet: NewWalletState
	public var restoreWallet: RestoreWalletState
	
	public var newPIN: NewPINState
	
	public init(
		newWalletOrRestore: NewWalletOrRestoreState = .init(),
		newWallet: NewWalletState = .init(),
		restoreWallet: RestoreWalletState = .init(),
		newPIN: NewPINState = .init()
	) {
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
			return .none
		case .newWalletOrRestore(.delegate(.restoreWallet)):
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
		Text("SetupWalletCoordinatorView")
	}
}
