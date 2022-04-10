//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import PIN
import Screen
import Styleguide
import SwiftUI

public enum UnlockApp {}


public extension UnlockApp {
	enum Role {
		case unlockApp
		case removePIN
		case removeWallet
	}
}
public extension UnlockApp {
	struct State: Equatable {
		
		public var role: Role
		/* @BindableState */ public var pinFieldText = ""
		public let expectedPIN: PIN
		public var showError: Bool = false
		public init(role: Role, expectedPIN: PIN) {
			self.role = role
			self.expectedPIN = expectedPIN
		}
	}
}

public extension UnlockApp {
	enum Action: Equatable {
		case pinFieldTextChanged(String)
		case delegate(Delegate)
		case wrongPIN
		case resetError
		case cancel
	}
}
public extension UnlockApp.Action {
	enum Delegate: Equatable {
		case userUnlockedApp, userCancelled
	}
}

public extension UnlockApp {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension UnlockApp {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		
		switch action {
		case let .pinFieldTextChanged(newPinText):
			state.pinFieldText = newPinText
			guard
				let pin = try? PIN(string: state.pinFieldText)
			else {
				return .none
			}
			guard
				pin == state.expectedPIN
			else {
				return Effect(value: .wrongPIN)
			}
			return Effect(value: .delegate(.userUnlockedApp))
			
		case .wrongPIN:
			state.showError = true
			return Effect(value: .resetError)
				.delay(for: 1, scheduler: environment.mainQueue)
				.eraseToEffect()
			
		case .resetError:
			state.pinFieldText = ""
			state.showError = false
			return .none
			// case .binding(_):
			// return .none
		case .cancel:
			assert(state.role != .unlockApp)
			return Effect(value: .delegate(.userCancelled))
		case .delegate(_):
			return .none
			
		}
	}
}

// MARK: - UnlockAppWithPINScreen
// MARK: -
public extension UnlockApp {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension UnlockApp.Screen {
	
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					SecureField(
						"PIN",
						text: viewStore.binding(
							get: \.pinFieldText,
							send: UnlockApp.Action.pinFieldTextChanged
						)
					)
					.disableAutocorrection(true)
					.textFieldStyle(.roundedBorder)
					.foregroundColor(.darkTurquoise)
					
					Text("Unlock app with PIN or FaceId/TouchId")
						.font(.zhip.body)
						.foregroundColor(viewStore.showError ? Color.bloodRed : Color.white)
				}
			}
			.navigationTitle(viewStore.navigationTitle)
			//				.toolbar {
			//					if viewStore.isUserAllowedToCancel {
			//						Button("Cancel") {
			//							viewStore.send(.cancelButtonTapped)
			//						}
			//					}
			//				}
		}
	}
}

// MARK: - View
// MARK: -
private extension UnlockApp.Screen {
	struct ViewState: Equatable {
		
		/* @BindableState */ var pinFieldText: String
		let showError: Bool
		let isUserAllowedToCancel: Bool
		let navigationTitle: String
		
		init(state: UnlockApp.State) {
			self.navigationTitle = state.role.navigationTitle
			self.isUserAllowedToCancel = state.role != .unlockApp
			self.pinFieldText = state.pinFieldText
			self.showError = state.showError
		}
	}
	
	//	enum ViewAction: Equatable, BindableAction {
	//		case binding(BindingAction<ViewState>)
	//		case cancelButtonTapped
	//	}
}


//extension UnlockAppState {
//	fileprivate var view: UnlockAppWithPINScreen.ViewState {
//		get { .init(state: self) }
//		set {
//			// handle bindable actions only:
//			self.pinFieldText = newValue.pinFieldText
//		}
//	}
//}
//
//extension UnlockAppAction {
//	fileprivate init(action: UnlockAppWithPINScreen.ViewAction) {
//		switch action {
//		case .binding(let bindingAction):
//			self = .binding(bindingAction.pullback(\UnlockAppState.view))
//		case .cancelButtonTapped:
//			self = .cancel
//		}
//	}
//}

private extension UnlockApp.Role {
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
