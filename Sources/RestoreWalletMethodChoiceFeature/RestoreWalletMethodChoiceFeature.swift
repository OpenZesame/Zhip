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


// MARK: ==================  DELIM  ==================
 

public struct RestoreWalletMethodChoiceState: Equatable {
	
	@BindableState public var method: Method
	public var usingPrivateKey: RestoreWalletUsingPrivateKeyState
	public var usingKeystore: RestoreWalletUsingKeystoreState
	
	public init(
		method: Method = .usingPrivateKey,
		usingPrivateKey: RestoreWalletUsingPrivateKeyState = .init(),
		usingKeystore: RestoreWalletUsingKeystoreState = .init()
	) {
		self.method = method
		self.usingKeystore = usingKeystore
		self.usingPrivateKey = usingPrivateKey
	}
}

public extension RestoreWalletMethodChoiceState {
	enum Method: Equatable {
		case usingPrivateKey
		case usingKeystore
	}
}
	

public enum RestoreWalletMethodChoiceAction: Equatable, BindableAction {
	case delegate(DelegateAction)
	
	case binding(BindingAction<RestoreWalletMethodChoiceState>)
	
	case usingPrivateKey(RestoreWalletUsingPrivateKeyAction)
	case usingKeystore(RestoreWalletUsingKeystoreAction)
	
}
public extension RestoreWalletMethodChoiceAction {
	enum DelegateAction: Equatable {
		case finishedRestoring(Wallet)
	}
}

public struct RestoreWalletMethodChoiceEnvironment {
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

public let restoreWalletMethodReducer = Reducer<
	RestoreWalletMethodChoiceState,
	RestoreWalletMethodChoiceAction,
	RestoreWalletMethodChoiceEnvironment
>.combine(
	
	restoreWalletUsingPrivateKeyReducer.pullback(
		state: \.usingPrivateKey,
		action: /RestoreWalletMethodChoiceAction.usingPrivateKey,
		environment: {
			RestoreWalletUsingPrivateKeyEnvironment(
				backgroundQueue: $0.backgroundQueue,
				mainQueue: $0.mainQueue,
				passwordValidator: $0.passwordValidator,
				walletRestorer: $0.walletRestorer
			)
		}
	),
	
	restoreWalletUsingKeystoreReducer.pullback(
		state: \.usingKeystore,
		action: /RestoreWalletMethodChoiceAction.usingKeystore,
		environment: { 
			RestoreWalletUsingKeystoreEnvironment(
				backgroundQueue: $0.backgroundQueue,
				mainQueue: $0.mainQueue,
				passwordValidator: $0.passwordValidator,
				walletRestorer: $0.walletRestorer
			)
		}
	),

	Reducer { state, action, environment in
		switch action {
		case let .usingKeystore(.delegate(.finishedRestoringWalletFromKeystore(wallet))):
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


public struct RestoreWalletScreen: View {
	let store: Store<RestoreWalletMethodChoiceState, RestoreWalletMethodChoiceAction>
	public init(
		store: Store<RestoreWalletMethodChoiceState, RestoreWalletMethodChoiceAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: - 
public extension RestoreWalletScreen {
    var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
	            VStack {
					Picker(selection: viewStore.binding(\.$method), content: {
						Text("Private key").tag(RestoreWalletMethodChoiceState.Method.usingPrivateKey)
						Text("Keystore").tag(RestoreWalletMethodChoiceState.Method.usingKeystore)
					}) {
						EmptyView() // No label
					}
					.pickerStyle(.segmented)

					switch viewStore.method {
					case .usingKeystore:
						RestoreWalletUsingKeystoreScreen(
							store: self.store.scope(
								state: \.usingKeystore,
								action: RestoreWalletMethodChoiceAction.usingKeystore
							)
						)
					case .usingPrivateKey:
						RestoreWalletUsingPrivateKeyScreen(
							store: self.store.scope(
								state: \.usingPrivateKey,
								action: RestoreWalletMethodChoiceAction.usingPrivateKey
							)
						)
					}
	            }
	            .navigationTitle("Restore existing wallet")
			}
		}
    }
}
