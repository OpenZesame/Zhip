//
//  InputNewPIN.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import PIN
import Screen
import Styleguide
import SwiftUI

public enum InputNewPIN {}

public extension InputNewPIN {
	struct State: Equatable {
		
		@BindableState public var pin: String
		public var canProceed = false
		
		public init(
			pin: String = ""
		) {
			self.pin = pin
			
#if DEBUG
			self.pin = "1234"
			self.canProceed = true
#endif
		}
	}
}

public extension InputNewPIN {
	enum Action: Equatable, BindableAction {
		case delegate(Delegate)
		case binding(BindingAction<State>)
		case skip
		case setPIN
	}
}
public extension InputNewPIN.Action {
	enum Delegate: Equatable {
		case finishedSettingPIN(PIN)
		case skip
	}
}

public extension InputNewPIN {
	struct Environment {
		public init() {}
	}
}

public extension InputNewPIN {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .setPIN:
			guard let pin = try? PIN(string: state.pin) else {
				return .none
			}
			return Effect(value: .delegate(.finishedSettingPIN(pin)))
		case .skip:
			return Effect(value: .delegate(.skip))
		case .binding(\.$pin):
			state.canProceed = (try? PIN(string: state.pin)) != nil
			return .none
		case .binding(_):
			return .none
		case .delegate(_):
			return .none
		}
	}.binding()
}

// MARK: - InputNewPINScreen
// MARK: -
public extension InputNewPIN {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

internal extension InputNewPIN.Screen {
	struct ViewState: Equatable {
		@BindableState var pin: String
		var canProceed: Bool
		init(state: InputNewPIN.State) {
			self.pin = state.pin
			self.canProceed = state.canProceed
		}
	}
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case doneButtonPressed
		case skipButtonPressed
	}
}

// MARK: - View
// MARK: -
public extension InputNewPIN.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: InputNewPIN.Action.init(action:)
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					//					PINField(text: $viewModel.pinFieldText, pin: $viewModel.pin)
					SecureField("PIN", text: viewStore.binding(\.$pin))
						.disableAutocorrection(true)
						.textFieldStyle(.roundedBorder)
						.foregroundColor(.darkTurquoise)
					
					Text("The app PIN is an extra safety measure used only to unlock the app. It is not used to encrypt your private key. Before setting a PIN, back up the wallet, otherwise you might get locked out of your wallet if you forget the PIN.")
						.font(.zhip.body)
						.foregroundColor(.silverGrey)
					
					Button("Done") {
						viewStore.send(.doneButtonPressed)
					}
					.buttonStyle(.primary)
					.enabled(if: viewStore.canProceed)
				}
				.navigationTitle("Set a PIN")
				.toolbar {
					Button("Skip") {
						viewStore.send(.skipButtonPressed)
					}
				}
			}
		}
	}
}

extension InputNewPIN.State {
	fileprivate var view: InputNewPIN.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.pin = newValue.pin
		}
	}
}


private extension InputNewPIN.Action {
	init(action: InputNewPIN.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\InputNewPIN.State.view))
		case .doneButtonPressed:
			self = .setPIN
		case .skipButtonPressed:
			self = .skip
		}
	}
}
