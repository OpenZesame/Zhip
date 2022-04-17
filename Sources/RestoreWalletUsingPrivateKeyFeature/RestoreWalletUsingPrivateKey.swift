//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Common
import ComposableArchitecture
import PasswordValidator
import Screen
import Styleguide
import SwiftUI
import Wallet
import WalletRestorer
import struct Zesame.PrivateKey

public enum RestoreWalletUsingPrivateKey {}

public extension RestoreWalletUsingPrivateKey {
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public var isRestoring: Bool
		public var canRestore: Bool
		@BindableState public var privateKeyHex: String
		@BindableState public var password: String
		@BindableState public var passwordConfirmation: String
		
		public init(
			isRestoring: Bool = false,
			canRestore: Bool = false,
			privateKeyHex: String = "",
			password: String = "",
			passwordConfirmation: String = ""
		) {
			self.isRestoring = isRestoring
			
			self.canRestore = canRestore
			self.privateKeyHex = privateKeyHex
			self.password = password
			self.passwordConfirmation = passwordConfirmation
			
#if DEBUG
			// Some uninteresting test account without any balance.
			self.privateKeyHex = "0xcc7d1263009ebbc8e31f5b7e7d79b625e57cf489cd540e1b0ac4801c8daab9be"
			
			self.password = unsafeDebugPassword
			self.passwordConfirmation = unsafeDebugPassword
			self.canRestore = true
#endif
		}
	}
}

public extension RestoreWalletUsingPrivateKey {
	enum Action: Equatable, BindableAction {
		case delegate(Delegate)
		
		case binding(BindingAction<State>)
		case alertDismissed
		case restore
		case restoreResult(Result<Wallet, WalletRestorerError>)
	}
}
public extension RestoreWalletUsingPrivateKey.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}

public extension RestoreWalletUsingPrivateKey {
	struct Environment {
		
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public var passwordValidator: PasswordValidator
		public var walletRestorer: WalletRestorer
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			walletRestorer: WalletRestorer
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.walletRestorer = walletRestorer
		}
	}
}

public extension RestoreWalletUsingPrivateKey {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		
		struct RestoreCancellationID: Hashable {}
		
		switch action {
		case .binding(_):
			state.canRestore = environment.passwordValidator
				.validatePasswords(
					.init(
						password: state.password,
						confirmPassword: state.passwordConfirmation
					)
				) != nil && PrivateKey(hex: state.privateKeyHex) != nil
			return .none
			
		case .restore:
			guard
				let privateKey = PrivateKey(hex: state.privateKeyHex)
			else {
				return .none
			}
			
			
			state.isRestoring = true
			
			let restoreRequest = RestoreWalletRequest(
				method: .privateKey(privateKey),
				encryptionPassword: state.password,
				name: nil
			)
			
			return environment.walletRestorer
				.restore(restoreRequest)
				.subscribe(on: environment.backgroundQueue)
				.receive(on: environment.mainQueue)
				.eraseToEffect()
				.cancellable(id: RestoreCancellationID(), cancelInFlight: true)
				.catchToEffect(RestoreWalletUsingPrivateKey.Action.restoreResult)
			
		case let .restoreResult(.success(wallet)):
			state.isRestoring = false
			return Effect(value: .delegate(.finished(wallet)))
		case let .restoreResult(.failure(error)):
			state.isRestoring = false
			state.alert = .init(title: .init("Failed to restore wallet, error: \(error.localizedDescription)"))
			return .none
			
		case .alertDismissed:
			state.alert = nil
			return .none
			
		case .delegate(_):
			return .none
		}
	}.binding()
}

// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
public extension RestoreWalletUsingPrivateKey {
	struct Screen: View {
		
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

internal extension RestoreWalletUsingPrivateKey.Screen {
	struct ViewState: Equatable {
		var isRestoring: Bool
		var canRestore: Bool
		@BindableState var privateKeyHex: String
		@BindableState var password: String
		@BindableState var passwordConfirmation: String
		
		init(state: RestoreWalletUsingPrivateKey.State) {
			self.isRestoring = state.isRestoring
			self.canRestore = state.canRestore
			self.privateKeyHex = state.privateKeyHex
			self.password = state.password
			self.passwordConfirmation = state.passwordConfirmation
		}
	}
	
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case restoreButtonTapped
		case alertDismissed
	}
}

extension RestoreWalletUsingPrivateKey.State {
	fileprivate var view: RestoreWalletUsingPrivateKey.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.privateKeyHex = newValue.privateKeyHex
			self.password = newValue.password
			self.passwordConfirmation = newValue.passwordConfirmation
		}
	}
}


private extension RestoreWalletUsingPrivateKey.Action {
	init(action: RestoreWalletUsingPrivateKey.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\RestoreWalletUsingPrivateKey.State.view))
		case .restoreButtonTapped:
			self = .restore
		case .alertDismissed:
			self = .alertDismissed
		}
	}
}

// MARK: - View
// MARK: -
public extension RestoreWalletUsingPrivateKey.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: RestoreWalletUsingPrivateKey.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack(spacing: 20) {
					
					SecureField("Private Key Hex", text: viewStore.binding(\.$privateKeyHex))
					
					SecureField("Encryption password", text: viewStore.binding(\.$password))
					SecureField("Confirm encryption password", text: viewStore.binding(\.$passwordConfirmation))
					
					
					Button("Restore") {
						viewStore.send(.restoreButtonTapped)
					}
					.buttonStyle(.primary(isLoading: viewStore.isRestoring))
					.enabled(if: viewStore.canRestore)
					
				}
				.foregroundColor(Color.asphaltGrey)
				.textFieldStyle(.roundedBorder)
				.disableAutocorrection(true)
			}
			.navigationTitle("Restore with private key")
			.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
		}
		
	}
}
