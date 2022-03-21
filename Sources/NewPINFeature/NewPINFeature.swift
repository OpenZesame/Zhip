//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import KeychainClient
import SwiftUI

public struct NewPINState: Equatable {
	public init() {}
}

public enum NewPINAction: Equatable {
	case delegate(DelegateAction)
}
public extension NewPINAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpPIN
		case skippedPIN
	}
}

public struct NewPINEnvironment {
	public let keychainClient: KeychainClient
	public init(
		keychainClient: KeychainClient
	) {
		self.keychainClient = keychainClient
	}
}

public let newPINReducer = Reducer<NewPINState, NewPINAction, NewPINEnvironment> { state, action, environment in
	return .none
}

public struct NewPINCoordinatorView: View {
	let store: Store<NewPINState, NewPINAction>
	public init(
		store: Store<NewPINState, NewPINAction>
	) {
		self.store = store
	}
}

public extension NewPINCoordinatorView {
	var body: some View {
		Text("NewPINCoordinatorView")
	}
}
