//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import NewWalletOrRestoreFeature
import SwiftUI

public struct SetupWalletState: Equatable {
	public var newWalletOrRestore: NewWalletOrRestoreState
	public var ensurePrivacy: EnsurePrivacyState
	public init(
		newWalletOrRestore: NewWalletOrRestoreState = .init(),
		ensurePrivacy: EnsurePrivacyState = .init()
	) {
		self.newWalletOrRestore = newWalletOrRestore
		self.ensurePrivacy = ensurePrivacy
	}
}

public enum SetupWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case newWalletOrRestore(NewWalletOrRestoreAction)
	case ensurePrivacy(EnsurePrivacyAction)
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
	
	ensurePrivacyReducer.pullback(
		state: \.ensurePrivacy,
		action: /SetupWalletAction.ensurePrivacy,
		environment: { _ in EnsurePrivacyEnvironment() }
	),
	
	Reducer<SetupWalletState, SetupWalletAction, SetupWalletEnvironment> { state, action, environment in
		switch action {
		case .newWalletOrRestore(.delegate(.generateNewWallet)):
			return .none
		case .newWalletOrRestore(.delegate(.restoreWallet)):
			return .none
		case .ensurePrivacy(.delegate(.abort)):
			return .none
		case .ensurePrivacy(.delegate(.proceed)):
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
