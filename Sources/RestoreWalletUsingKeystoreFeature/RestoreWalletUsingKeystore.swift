//
//  RestoreWalletUsingKeystoreScreen.swift
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
import struct Zesame.Keystore

public enum RestoreWalletUsingKeystore {}

public extension RestoreWalletUsingKeystore {
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public var isRestoring: Bool
		public var canRestore: Bool
		@BindableState public var keystore: String
		@BindableState public var password: String
		
		public init(
			isRestoring: Bool = false,
			canRestore: Bool = false,
			keystore: String = "",
			password: String = ""
		) {
			self.isRestoring = isRestoring
			
			self.canRestore = canRestore
			self.keystore = keystore
			self.password = password
			
#if DEBUG
			// Some uninteresting test account without any balance.
			self.keystore = unsafeKeystoreJSON
			
			self.password = unsafeDebugPassword
			self.canRestore = true
#endif
		}
	}
}

public extension RestoreWalletUsingKeystore {
	enum Action: Equatable, BindableAction {
		case delegate(Delegate)
		
		case binding(BindingAction<State>)
		case alertDismissed
		case restore
		case restoreResult(Result<Wallet, WalletRestorerError>)
	}
}
public extension RestoreWalletUsingKeystore.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}

public extension RestoreWalletUsingKeystore {
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

public extension RestoreWalletUsingKeystore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		
		struct RestoreCancellationID: Hashable {}
		
		switch action {
		case .binding(_):
			state.canRestore = environment.passwordValidator
				.validatePasswords(
					.single(password: state.password)
				) != nil && Keystore(string: state.keystore) != nil
			return .none
			
		case .restore:
			guard
				let keystore = Keystore(string: state.keystore)
			else {
				return .none
			}
			
			state.isRestoring = true
			
			let restoreRequest = RestoreWalletRequest(
				method: .keystore(keystore),
				encryptionPassword: state.password,
				name: nil
			)
			
			return environment.walletRestorer
				.restore(restoreRequest)
				.subscribe(on: environment.backgroundQueue)
				.receive(on: environment.mainQueue)
				.eraseToEffect()
				.cancellable(id: RestoreCancellationID(), cancelInFlight: true)
				.catchToEffect(RestoreWalletUsingKeystore.Action.restoreResult)
			
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

public extension RestoreWalletUsingKeystore {
	struct Screen: View {
		let store: Store<State, Action>
		
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

internal extension RestoreWalletUsingKeystore.Screen {
	struct ViewState: Equatable {
		var isRestoring: Bool
		var canRestore: Bool
		@BindableState var keystore: String
		@BindableState var password: String
		
		init(state: RestoreWalletUsingKeystore.State) {
			self.isRestoring = state.isRestoring
			self.canRestore = state.canRestore
			self.keystore = state.keystore
			self.password = state.password
		}
	}
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case restoreButtonTapped
		case alertDismissed
	}
}

extension RestoreWalletUsingKeystore.State {
	fileprivate var view: RestoreWalletUsingKeystore.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.keystore = newValue.keystore
			self.password = newValue.password
		}
	}
}

private extension RestoreWalletUsingKeystore.Action {
	init(action: RestoreWalletUsingKeystore.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\RestoreWalletUsingKeystore.State.view))
		case .restoreButtonTapped:
			self = .restore
		case .alertDismissed:
			self = .alertDismissed
		}
	}
}


// MARK: - View
// MARK: -
public extension RestoreWalletUsingKeystore.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: RestoreWalletUsingKeystore.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					TextEditor(text: viewStore.binding(\.$keystore))
						.foregroundColor(Color.deepBlue)
						.font(.zhip.body)
					
					SecureField("Encryption password", text: viewStore.binding(\.$password))
					
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
			.navigationTitle("Restore with keystore")
			.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
		}
	}
}

// MARK: Keystore
private extension Keystore {
	init?(string: String) {
		guard let json = string.data(using: .utf8) else {
			return nil
		}
		
		do {
			self = try JSONDecoder().decode(Keystore.self, from: json)
		} catch {
			return nil
		}
	}
}

#if DEBUG
let unsafeKeystoreJSON =
"""
{
  "version" : 3,
  "id" : "9F96BFFE-4213-4F21-9FE7-2798B67F2167",
  "crypto" : {
 "ciphertext" : "3daf4cfd5b469f3eb383b7269ad678e46f4da9cf0c1efed88c86eafc1d2a215e",
 "cipherparams" : {
   "iv" : "26d5d4e274634c1595db37786d431f9f"
 },
 "kdf" : "pbkdf2",
 "kdfparams" : {
   "r" : 8,
   "p" : 1,
   "n" : 1,
   "c" : 1,
   "dklen" : 32,
   "salt" : "074bfeeea625439bd10c7045b60d5653ce1196a99226d8bd187e821703e25cc1"
 },
 "mac" : "b9f5766a815822ed0877e2cef2037e6abc9633ee590a24240d606321c31588bc",
 "cipher" : "aes-128-ctr"
  },
  "address" : "Be1d30e0268F9417560CeBC11E2959B2FC098922"
}
"""
#endif
