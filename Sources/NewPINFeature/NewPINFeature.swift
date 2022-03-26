//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import KeychainClient
import PINCode
import Screen
import Styleguide
import SwiftUI
import Wallet

public struct NewPINState: Equatable {
	public var wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}

public enum NewPINAction: Equatable {
	case delegate(DelegateAction)
	case skip
}
public extension NewPINAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpPIN(wallet: Wallet, pin: Pincode)
		case skippedPIN(wallet: Wallet)
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
	switch action {
	case .skip:
		return Effect(value: .delegate(.skippedPIN(wallet: state.wallet)))
	case .delegate(_):
		return .none
	}
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
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Text("NewPINCoordinatorView")
					Button("Skip") {
						viewStore.send(.skip)
					}
				}
			}
		}
		
	}
}
