//
//  RestoreWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import PasswordValidator
import RestoreWalletUsingPrivateKeyFeature
import RestoreWalletUsingKeystoreFeature
import SwiftUI
import Styleguide
import Screen
import Wallet
import WalletRestorer

public enum RestoreWalletMethodChoice {}

public extension RestoreWalletMethodChoice {
	struct State: Equatable {
		
		@BindableState public var method: Method
		public var usingPrivateKey: RestoreWalletUsingPrivateKeyState
		public var usingKeystore: RestoreWalletUsingKeystore.State
		
		public init(
			method: Method = .usingPrivateKey,
			usingPrivateKey: RestoreWalletUsingPrivateKeyState = .init(),
			usingKeystore: RestoreWalletUsingKeystore.State = .init()
		) {
			self.method = method
			self.usingKeystore = usingKeystore
			self.usingPrivateKey = usingPrivateKey
		}
	}
}


public extension RestoreWalletMethodChoice.State {
	enum Method: Equatable {
		case usingPrivateKey
		case usingKeystore
	}
}


public extension RestoreWalletMethodChoice {
	enum Action: Equatable, BindableAction {
		case delegate(Delegate)
		
		case binding(BindingAction<State>)
		
		case usingPrivateKey(RestoreWalletUsingPrivateKeyAction)
		case usingKeystore(RestoreWalletUsingKeystore.Action)
		
	}
}
public extension RestoreWalletMethodChoice.Action {
	enum Delegate: Equatable {
		case finishedRestoring(Wallet)
	}
}

public extension RestoreWalletMethodChoice {
	struct Environment {
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let passwordValidator: PasswordValidator
		public let walletRestorer: WalletRestorer
		
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

public extension RestoreWalletMethodChoice {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		restoreWalletUsingPrivateKeyReducer.pullback(
			state: \.usingPrivateKey,
			action: /RestoreWalletMethodChoice.Action.usingPrivateKey,
			environment: {
				RestoreWalletUsingPrivateKeyEnvironment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletRestorer: $0.walletRestorer
				)
			}
		),
		
		RestoreWalletUsingKeystore.reducer.pullback(
			state: \.usingKeystore,
			action: /RestoreWalletMethodChoice.Action.usingKeystore,
			environment: {
				RestoreWalletUsingKeystore.Environment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					walletRestorer: $0.walletRestorer
				)
			}
		),
		
		Reducer { state, action, environment in
			switch action {
			case let .usingKeystore(.delegate(.finished(wallet))):
				return Effect(value: .delegate(.finishedRestoring(wallet)))
				
			case .usingKeystore(_):
				return .none
				
			case let .usingPrivateKey(.delegate(.finishedRestoringWalletFromPrivateKey(wallet))):
				return Effect(value: .delegate(.finishedRestoring(wallet)))
			case .usingPrivateKey(_):
				return .none
				
			case .binding(_):
				return .none
				
			case .delegate(_):
				return .none
			}
		}
	).binding()
}


public extension RestoreWalletMethodChoice {
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
public extension RestoreWalletMethodChoice.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Picker(selection: viewStore.binding(\.$method), content: {
						Text("Private key").tag(RestoreWalletMethodChoice.State.Method.usingPrivateKey)
						Text("Keystore").tag(RestoreWalletMethodChoice.State.Method.usingKeystore)
					}) {
						EmptyView() // No label
					}
					.pickerStyle(.segmented)
					
					switch viewStore.method {
					case .usingKeystore:
						RestoreWalletUsingKeystore.Screen(
							store: self.store.scope(
								state: \.usingKeystore,
								action: RestoreWalletMethodChoice.Action.usingKeystore
							)
						)
					case .usingPrivateKey:
						RestoreWalletUsingPrivateKeyScreen(
							store: self.store.scope(
								state: \.usingPrivateKey,
								action: RestoreWalletMethodChoice.Action.usingPrivateKey
							)
						)
					}
				}
				.navigationTitle("Restore existing wallet")
			}
		}
	}
}
