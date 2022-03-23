//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import PINCode
import PINField
import Screen
import Styleguide
import SwiftUI

public struct UnlockAppState: Equatable {
	public enum Role {
		case unlockApp
		case removePIN
		case removeWallet
	}
	public var role: Role
	public var pinFieldText = ""
	public let expectedPIN: Pincode
	public var pinCode: Pincode?
	public var showError: Bool = false
	public init(role: Role, expectedPIN: Pincode) {
		self.role = role
		self.expectedPIN = expectedPIN
	}
}

public enum UnlockAppAction: Equatable {
	case delegate(DelegateAction)
	case pinFieldTextChanged(String)
	case pincodeChanged(Pincode?)
	
	case cancel
}
public extension UnlockAppAction {
	enum DelegateAction: Equatable {
		case userUnlockedApp, userCancelled
	}
}

public struct UnlockAppEnvironment {
	public let keychainClient: KeychainClient
	public init(keychainClient: KeychainClient) {
		self.keychainClient = keychainClient
	}
}

public let unlockAppReducer = Reducer<UnlockAppState, UnlockAppAction, UnlockAppEnvironment> { state, action, environment in
	switch action {
	case let .pinFieldTextChanged(pinFieldText):
		state.pinFieldText = pinFieldText
		//Validate?
		return .none
	case let .pincodeChanged(pin):
		state.pinCode = pin
		//Validate?
		return .none
	case .cancel:
		assert(state.role != .unlockApp)
		return Effect(value: .delegate(.userCancelled))
	case .delegate(_):
		return .none
	}
}

// MARK: - UnlockAppWithPINScreen
// MARK: -
public struct UnlockAppWithPINScreen: View {
	let store: Store<UnlockAppState, UnlockAppAction>
	public init(
		store: Store<UnlockAppState, UnlockAppAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension UnlockAppWithPINScreen {
	
	var body: some View {
		WithViewStore(store.scope(state: ViewState.init)) { viewStore in
			ForceFullScreen {
				VStack {
					PINField(
						text: viewStore.binding(
							get: \.pinFieldText,
							send: UnlockAppAction.pinFieldTextChanged
						),
						pinCode: viewStore.binding(
							get: \.pinCode,
							send: UnlockAppAction.pincodeChanged
						),
						errorMessage: viewStore.showError ? "Invalid PIN" : nil
					)
					
					Text("Unlock app with PIN or FaceId/TouchId")
						.font(.zhip.body).foregroundColor(.silverGrey)
				}
				.navigationTitle(viewStore.navigationTitle)
				.toolbar {
					if viewStore.isUserAllowedToCancel {
						Button("Cancel") {
							viewStore.send(.cancel)
						}
					}
				}
			}
		}
	}
}

// MARK: - View
// MARK: -
private extension UnlockAppWithPINScreen {
	struct ViewState: Equatable {
		
		let pinFieldText: String
		let pinCode: Pincode?
		let showError: Bool
		let isUserAllowedToCancel: Bool
		let navigationTitle: String
		
		init(state: UnlockAppState) {
			self.navigationTitle = state.role.navigationTitle
			self.isUserAllowedToCancel = state.role != .unlockApp
			self.pinCode = state.pinCode
			self.pinFieldText = state.pinFieldText
			self.showError = state.showError
		}
	}
}

private extension UnlockAppState.Role {
	var navigationTitle: String {
        switch self {
        case .unlockApp:
            return "Unlock app"
        case .removePIN:
            return "Remove PIN"
        case .removeWallet:
            return "Remove wallet"
        }
    }
}
