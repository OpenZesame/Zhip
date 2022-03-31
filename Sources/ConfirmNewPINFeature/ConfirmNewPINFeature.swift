//
//  ConfirmNewPINCodeScreen.swift
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

public struct ConfirmNewPINState: Hashable {
	
	public var expectedPIN: Pincode
	
	@BindableState public var pin: String
	
	public var canProceed: Bool
	public var userHasConfirmedBackingUpPIN: Bool
	public var showError: Bool

	public init(
		expectedPIN: Pincode,
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
public enum ConfirmNewPINAction: Equatable, BindableAction {
	case delegate(DelegateAction)
	case binding(BindingAction<ConfirmNewPINState>)
	case confirmPIN
	case skip
	case wrongPIN, resetError
}
public extension ConfirmNewPINAction {
	enum DelegateAction: Equatable {
		case finishedConfirmingPIN(Pincode)
		case skip
	}
}

public struct ConfirmNewPINEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
	
}

public let confirmNewPINReducer = Reducer<
	ConfirmNewPINState,
	ConfirmNewPINAction,
	ConfirmNewPINEnvironment
> { state, action, environment in
	switch action {
	case .confirmPIN:
		guard let pin = try? Pincode(string: state.pin) else {
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
		state.canProceed = (try? Pincode(string: state.pin)) != nil && state.userHasConfirmedBackingUpPIN
		return .none
	case .delegate(_):
		return .none
	}
}.binding()

// MARK: - ConfirmNewPINScreen
// MARK: -
public struct ConfirmNewPINScreen: View {
	let store: Store<ConfirmNewPINState, ConfirmNewPINAction>
	public init(
		store: Store<ConfirmNewPINState, ConfirmNewPINAction>
	) {
		self.store = store
	}
}

internal extension ConfirmNewPINScreen {
	struct ViewState: Equatable {
		@BindableState var pin: String
		var canProceed: Bool
		@BindableState var userHasConfirmedBackingUpPIN: Bool
		var showError: Bool
		init(state: ConfirmNewPINState) {
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
public extension ConfirmNewPINScreen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: ConfirmNewPINAction.init(action:)
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

extension ConfirmNewPINState {
	fileprivate var view: ConfirmNewPINScreen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.pin = newValue.pin
			self.userHasConfirmedBackingUpPIN = newValue.userHasConfirmedBackingUpPIN
		}
	}
}


private extension ConfirmNewPINAction {
	init(action: ConfirmNewPINScreen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\ConfirmNewPINState.view))
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
	) -> ConfirmNewPINState {
		.init(
			expectedPIN: try! Pincode(string: "1234"),
			pin: pin,
			userHasConfirmedBackingUpPIN: isOn,
			showError: showError,
			canProceed: isOn && !showError
		)
	}
}

public struct ConfirmNewPINScreen_Previews: PreviewProvider {
	
	
	private static let states: [ConfirmNewPINState] = [
		Self.state(showError: false, isBoxChecked: false),
		Self.state(showError: false, isBoxChecked: true),
		Self.state(showError: true, isBoxChecked: false),
		Self.state(showError: true, isBoxChecked: true),
	]
	
	public static var previews: some View {
		Group {
			ForEach(states, id: \.self) { state in
				NavigationView {
					ConfirmNewPINScreen(
						store: .init(
							initialState: state,
							reducer: confirmNewPINReducer,
							environment: ConfirmNewPINEnvironment(
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
