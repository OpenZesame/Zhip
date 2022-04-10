//
//  ConfirmNewPINScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import Checkbox
import Common
import ComposableArchitecture
import PINField
import Screen
import Styleguide
import SwiftUI

public enum ConfirmNewPIN {}

public extension ConfirmNewPIN {
	struct State: Hashable {
		
		public var expectedPIN: PIN
		
		@BindableState public var pin: String
		
		public var canProceed: Bool
		public var userHasConfirmedBackingUpPIN: Bool
		public var showError: Bool
		
		public init(
			expectedPIN: PIN,
			pin: String = "",
			userHasConfirmedBackingUpPIN: Bool = false,
			showError: Bool = false,
			canProceed: Bool = false
		) {
			self.expectedPIN = expectedPIN
			self.pin = pin
			self.showError = showError
			self.userHasConfirmedBackingUpPIN = userHasConfirmedBackingUpPIN
			self.canProceed = canProceed
			
			//		#if DEBUG
			//		self.pin = "1234"
			//		self.canProceed = true
			//		#endif
		}
	}
}


public extension ConfirmNewPIN {
	enum Action: Equatable, BindableAction {
		case delegate(Delegate)
		case binding(BindingAction<State>)
		case confirmPIN
		case skip
		case wrongPIN, resetError
	}
}

public extension ConfirmNewPIN.Action {
	enum Delegate: Equatable {
		case finishedConfirmingPIN(PIN)
		case skip
	}
}

public extension ConfirmNewPIN {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
		
	}
}

public extension ConfirmNewPIN {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .confirmPIN:
			guard let pin = try? PIN(string: state.pin) else {
				return .none
			}
			
			guard state.userHasConfirmedBackingUpPIN else {
				return .none
			}
			
			guard pin == state.expectedPIN else {
				return Effect(value: .wrongPIN)
			}
			
			return Effect(value: .delegate(.finishedConfirmingPIN(state.expectedPIN)))
			
		case .wrongPIN:
			state.showError = true
			return Effect(value: .resetError)
				.delay(for: 1, scheduler: environment.mainQueue)
				.eraseToEffect()
			
		case .resetError:
			state.pin = ""
			state.showError = false
			return .none
			
		case .skip:
			return Effect(value: .delegate(.skip))
		case let .binding(bindingAction):
			state.canProceed = (try? PIN(string: state.pin)) != nil && state.userHasConfirmedBackingUpPIN
			return .none
		case .delegate(_):
			return .none
		}
	}.binding()
}

// MARK: - ConfirmNewPINScreen
// MARK: -
public extension ConfirmNewPIN {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

internal extension ConfirmNewPIN.Screen {
	struct ViewState: Equatable {
		@BindableState var pin: String
		var canProceed: Bool
		@BindableState var userHasConfirmedBackingUpPIN: Bool
		var showError: Bool
		init(state: ConfirmNewPIN.State) {
			self.pin = state.pin
			self.canProceed = state.canProceed
			self.userHasConfirmedBackingUpPIN = state.userHasConfirmedBackingUpPIN
			self.showError = state.showError
		}
	}
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case confirmPINButtonTapped
		case skipButtonPressed
	}
}


// MARK: - View
// MARK: -
public extension ConfirmNewPIN.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: ConfirmNewPIN.Action.init(action:)
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					
					SecureField("PIN", text: viewStore.binding(\.$pin))
						.disableAutocorrection(true)
						.textFieldStyle(.roundedBorder)
						.foregroundColor(.darkTurquoise)
					
					Text("Pins do not match")
						.font(.zhip.title)
						.foregroundColor(.bloodRed)
						.visibility(viewStore.showError ? .visible : .invisible)
					
					Checkbox(
						"I have securely backed up my PIN.",
						isOn: viewStore.binding(\.$userHasConfirmedBackingUpPIN)
					)
					
					Button("Confirm") {
						viewStore.send(.confirmPINButtonTapped)
					}
					.buttonStyle(.primary)
					.disabled(!viewStore.canProceed)
				}
				.navigationTitle("Confirm PIN")
#if os(iOS)
				.navigationBarTitleDisplayMode(.inline)
#endif
				.toolbar {
					Button("Skip PIN") {
						viewStore.send(.skipButtonPressed)
					}
				}
				
			}
		}
	}
}

extension ConfirmNewPIN.State {
	fileprivate var view: ConfirmNewPIN.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.pin = newValue.pin
			self.userHasConfirmedBackingUpPIN = newValue.userHasConfirmedBackingUpPIN
		}
	}
}


private extension ConfirmNewPIN.Action {
	init(action: ConfirmNewPIN.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\ConfirmNewPIN.State.view))
		case .confirmPINButtonTapped:
			self = .confirmPIN
		case .skipButtonPressed:
			self = .skip
		}
	}
}

#if DEBUG

private extension ConfirmNewPINScreen_Previews {
	static func state(
		pin: String = "",
		showError: Bool,
		isBoxChecked isOn: Bool
	) -> ConfirmNewPIN.State {
		.init(
			expectedPIN: try! PIN(string: "1234"),
			pin: pin,
			userHasConfirmedBackingUpPIN: isOn,
			showError: showError,
			canProceed: isOn && !showError
		)
	}
}

public struct ConfirmNewPINScreen_Previews: PreviewProvider {
	
	
	private static let states: [ConfirmNewPIN.State] = [
		Self.state(showError: false, isBoxChecked: false),
		Self.state(showError: false, isBoxChecked: true),
		Self.state(showError: true, isBoxChecked: false),
		Self.state(showError: true, isBoxChecked: true),
	]
	
	public static var previews: some View {
		Group {
			ForEach(states, id: \.self) { state in
				NavigationView {
					ConfirmNewPIN.Screen(
						store: .init(
							initialState: state,
							reducer: ConfirmNewPIN.reducer,
							environment: ConfirmNewPIN.Environment(
								mainQueue: DispatchQueue.main.eraseToAnyScheduler()
							)
						)
					)
				}
				.foregroundColor(Color.white)
			}
		}
	}
}
#endif
