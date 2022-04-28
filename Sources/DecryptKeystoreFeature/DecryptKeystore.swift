//
//  DecryptKeystoreToRevealKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import Combine
import ComposableArchitecture
import InputField
import Password
import PasswordValidator
import Screen
import Styleguide
import SwiftUI
import Wallet

public enum DecryptKeystore {}

public extension DecryptKeystore {
	struct State: Equatable {
		@BindableState public var password: String
		public var canDecrypt: Bool
		public var isDecrypting: Bool
		public init(
			password: String = "",
			canDecrypt: Bool = false,
			isDecrypting: Bool = false
		) {
			self.password = password
			self.canDecrypt = canDecrypt
			self.isDecrypting = isDecrypting
		}
	}
}

public extension DecryptKeystore {
	enum Action: Equatable, BindableAction {
		case binding(BindingAction<State>)
		case `internal`(Internal)
		case delegate(Delegate)
	}
}
public extension DecryptKeystore.Action {
	enum Internal: Equatable {
		case decrypt
		case decryptionResult(Result<KeyPairHex, Never>)
	}

	enum Delegate: Equatable {
		case decryptedKeyPair(KeyPairHex)
	}
}


public extension DecryptKeystore {
	struct Environment {
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let wallet: Wallet
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			wallet: Wallet
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
			self.wallet = wallet
		}
	}
}
public extension DecryptKeystore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .binding(_):
			state.canDecrypt = !state.password.isEmpty // FIXME replace with password validator
			return .none
		case .internal(.decrypt):
			
			let password: Password = .init(state.password)
			let request = ExportPrivateKeyRequest(encryptionPassword: password)
			
			state.isDecrypting = true
			
			return environment.wallet
				.exportKeyPair(request)
				.subscribe(on: environment.backgroundQueue)
				.receive(on: environment.mainQueue)
				.catchToEffect {
					Action.internal(.decryptionResult($0))
				}
		case let .internal(.decryptionResult(.success(keyPairHex))):
			state.isDecrypting = false
			return Effect(value: .delegate(.decryptedKeyPair(keyPairHex)))
			
		case let .internal(.decryptionResult(.failure(error))):
			state.isDecrypting = false
			fatalError("\(error)")
		case .delegate(_):
			return .none
		}
	}.binding()
}


// MARK: - DecryptKeystoreToRevealKeyPairScreen
// MARK: -
public extension DecryptKeystore {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension DecryptKeystore.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: DecryptKeystore.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					
					Text("Enter your encryption password to reveal your private and public key.")
					
					SecureField("Encryption Password", text: viewStore.binding(\.$password))
					
//					InputField(
//						prompt: "Encryption password",
//						text: viewStore.password,
//						isValid: $viewModel.isPasswordOnValidFormat,
//						isSecure: true,
//						validationRules: .encryptionPassword
//					)
					
					Spacer()
					
					Button("Reveal") {
						viewStore.send(.revealButtonTapped)
					}
					.disabled(!viewStore.canDecrypt)
					.buttonStyle(.primary(isLoading: viewStore.isDecrypting))
				}
				.foregroundColor(Color.asphaltGrey)
				.textFieldStyle(.roundedBorder)
				.navigationTitle("Decrypt keystore")
			}
		}
	}
}

extension DecryptKeystore.Screen {
	struct ViewState: Equatable {
		let canDecrypt: Bool
		let isDecrypting: Bool
		@BindableState var password: String
		init(state: DecryptKeystore.State) {
			self.canDecrypt = state.canDecrypt
			self.isDecrypting = state.isDecrypting
			self.password = state.password
		}
	}
	
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case revealButtonTapped
	}
}

private extension DecryptKeystore.Action {
	init(action: DecryptKeystore.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\DecryptKeystore.State.view))
		case .revealButtonTapped:
			self = .internal(.decrypt)
		}
	}
}

extension DecryptKeystore.State {
	fileprivate var view: DecryptKeystore.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.password = newValue.password
		}
	}
}


		
