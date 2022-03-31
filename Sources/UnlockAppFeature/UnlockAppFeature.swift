//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import PINCode
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
	@BindableState var pinFieldText = ""
	public let expectedPIN: Pincode
//	@BindableState public var pinCode: Pincode?
	public var showError: Bool = false
	public init(role: Role, expectedPIN: Pincode) {
		self.role = role
		self.expectedPIN = expectedPIN
	}
}

public enum UnlockAppAction: Equatable, BindableAction {
	case binding(BindingAction<UnlockAppState>)
	case delegate(DelegateAction)
	case wrongPIN
	case resetError
	case cancel
}
public extension UnlockAppAction {
	enum DelegateAction: Equatable {
		case userUnlockedApp, userCancelled
	}
}

public struct UnlockAppEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let unlockAppReducer = Reducer<UnlockAppState, UnlockAppAction, UnlockAppEnvironment> { state, action, environment in
	
	switch action {
	case .binding(\.$pinFieldText):
		print("✨ state.pinFieldText: \(state.pinFieldText)")
		guard
			let pin = try? Pincode(string: state.pinFieldText)
		else {
			return .none
		}
		print("✨ pin: \(pin.debugDescription)")
		guard
			pin == state.expectedPIN
		else {
			print("✨ pin WRONG expected: \(state.expectedPIN.debugDescription)")
			return Effect(value: .wrongPIN)
		}
		print("✅ correct PIN!")
		return Effect(value: .delegate(.userUnlockedApp))

	case .wrongPIN:
		state.pinFieldText = ""
		state.showError = true
		return Effect(value: .resetError)
			.debounce(for: 1, scheduler: environment.mainQueue)
			.eraseToEffect()
		
	case .resetError:
		state.showError = false
		return .none
	case .binding(_):
		return .none
	case .cancel:
		assert(state.role != .unlockApp)
		return Effect(value: .delegate(.userCancelled))
	case .delegate(_):
		return .none

	}
}
.binding()

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
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: UnlockAppAction.init(action:)
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
//					PINField(
//						text: viewStore.binding(
//							get: \.pinFieldText,
//							send: UnlockAppAction.pinFieldTextChanged
//						),
//						pinCode: viewStore.binding(
//							get: \.pinCode,
//							send: UnlockAppAction.pincodeChanged
//						),
//						errorMessage: viewStore.showError ? "Invalid PIN" : nil
//					)
					SecureField("PIN", text: viewStore.binding(\.$pinFieldText))
						.disableAutocorrection(true)
						.textFieldStyle(.roundedBorder)
						.foregroundColor(.darkTurquoise)
					
					Text("Unlock app with PIN or FaceId/TouchId")
						.font(.zhip.body).foregroundColor(.silverGrey)
				}
				.background(viewStore.showError ? Color.bloodRed : Color.clear)
				.navigationTitle(viewStore.navigationTitle)
				.toolbar {
					if viewStore.isUserAllowedToCancel {
						Button("Cancel") {
							viewStore.send(.cancelButtonTapped)
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
		
		@BindableState var pinFieldText: String
//		@BindableState var pinCode: Pincode?
		let showError: Bool
		let isUserAllowedToCancel: Bool
		let navigationTitle: String
		
		init(state: UnlockAppState) {
			self.navigationTitle = state.role.navigationTitle
			self.isUserAllowedToCancel = state.role != .unlockApp
//			self.pinCode = state.pinCode
			self.pinFieldText = state.pinFieldText
			self.showError = state.showError
		}
	}
	
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case cancelButtonTapped
	}
}


extension UnlockAppState {
	fileprivate var view: UnlockAppWithPINScreen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.pinFieldText = newValue.pinFieldText
		}
	}
}

extension UnlockAppAction {
	fileprivate init(action: UnlockAppWithPINScreen.ViewAction) {
		switch action {
		case .binding(let bindingAction):
			self = .binding(bindingAction.pullback(\UnlockAppState.view))
		case .cancelButtonTapped:
			self = .cancel
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
