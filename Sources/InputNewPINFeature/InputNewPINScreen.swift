//
//  NewPINCodeScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import PINCode
import Screen
import Styleguide
import SwiftUI

public struct InputNewPINState: Equatable {
	@BindableState public var pin: String
	public var canProceed: Bool
	public init(
		pin: String = "",
		canProceed: Bool = false
	) {
		self.pin = pin
		self.canProceed = canProceed
		#if DEBUG
		self.pin = "1234"
		self.canProceed = true
		#endif
	}
}

public enum InputNewPINAction: Equatable, BindableAction {
	case delegate(DelegateAction)
	case binding(BindingAction<InputNewPINState>)
	case skip
	case setPIN
}
public extension InputNewPINAction {
	enum DelegateAction: Equatable {
		case finishedSettingPIN(Pincode)
		case skip
	}
}

public struct InputNewPINEnvironment {
	public init() {}
}

public let inputNewPINReducer = Reducer<
	InputNewPINState,
	InputNewPINAction,
	InputNewPINEnvironment
> { state, action, environment in
	switch action {
	case .setPIN:
		guard let pin = try? Pincode(string: state.pin) else {
			return .none
		}
		return Effect(value: .delegate(.finishedSettingPIN(pin)))
	case .skip:
		return Effect(value: .delegate(.skip))
	case .binding(\.$pin):
		state.canProceed = (try? Pincode(string: state.pin)) != nil
		return .none
	case .binding(_):
		return .none
	case .delegate(_):
		return .none
	}
}.binding()

// MARK: - InputNewPINCodeScreen
// MARK: -
public struct InputNewPINCodeScreen: View {
	let store: Store<InputNewPINState, InputNewPINAction>
	public init(
		store: Store<InputNewPINState, InputNewPINAction>
	) {
		self.store = store
	}
}

internal extension InputNewPINCodeScreen {
	struct ViewState: Equatable {
		@BindableState var pin: String
		var canProceed: Bool
		init(state: InputNewPINState) {
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
public extension InputNewPINCodeScreen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: InputNewPINAction.init(action:)
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
//					PINField(text: $viewModel.pinFieldText, pinCode: $viewModel.pinCode)
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

extension InputNewPINState {
	fileprivate var view: InputNewPINCodeScreen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.pin = newValue.pin
		}
	}
}


private extension InputNewPINAction {
	init(action: InputNewPINCodeScreen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\InputNewPINState.view))
		case .doneButtonPressed:
			self = .setPIN
		case .skipButtonPressed:
			self = .skip
		}
	}
}
