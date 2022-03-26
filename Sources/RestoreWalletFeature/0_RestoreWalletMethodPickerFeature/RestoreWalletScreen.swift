//
//  RestoreWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import PasswordValidator
import SwiftUI
import Styleguide
import Screen
import Wallet


// MARK: ==================  DELIM  ==================
 

public struct RestoreWalletMethodState: Equatable {
	
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

public extension RestoreWalletMethodState {
	enum Method: Equatable {
		case usingPrivateKey
		case usingKeystore
	}
}
	

public enum RestoreWalletMethodAction: Equatable, BindableAction {
	case delegate(DelegateAction)
	
	case binding(BindingAction<RestoreWalletMethodState>)
	
	case usingPrivateKey(RestoreWalletUsingPrivateKeyAction)
	case usingKeystore(RestoreWalletUsingKeystoreAction)
	
}
public extension RestoreWalletMethodAction {
	enum DelegateAction: Equatable {
		case finishedRestoring(Wallet)
	}
}

public struct RestoreWalletMethodEnvironment {
	public let passwordValidator: PasswordValidator
	public init(
		passwordValidator: PasswordValidator
	) {
		self.passwordValidator = passwordValidator
	}
}

public let restoreWalletMethodReducer = Reducer<
	RestoreWalletMethodState,
	RestoreWalletMethodAction,
	RestoreWalletMethodEnvironment
>.combine(
	
	restoreWalletUsingPrivateKeyReducer.pullback(
		state: \.usingPrivateKey,
		action: /RestoreWalletMethodAction.usingPrivateKey,
		environment: {
			RestoreWalletUsingPrivateKeyEnvironment(
				passwordValidator: $0.passwordValidator
			)
		}
	),
	
	restoreWalletUsingKeystoreReducer.pullback(
		state: \.usingKeystore,
		action: /RestoreWalletMethodAction.usingKeystore,
		environment: { _ in
			RestoreWalletUsingKeystoreEnvironment()
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
	}.binding()
).binding()


public struct RestoreWalletScreen: View {
	let store: Store<RestoreWalletMethodState, RestoreWalletMethodAction>
	public init(
		store: Store<RestoreWalletMethodState, RestoreWalletMethodAction>
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
						Text("Private key").tag(RestoreWalletMethodState.Method.usingPrivateKey)
						Text("Keystore").tag(RestoreWalletMethodState.Method.usingKeystore)
					}) {
						EmptyView() // No label
					}
					.pickerStyle(.segmented)
					
//					SwitchStore(viewStore.method) {
//						CaseLet(
//							state: /RestoreWalletMethodState.Method.usingPrivateKey,
//							action: RestoreWalletMethodAction.usingPrivateKey,
//							then: RestoreWalletUsingPrivateKeyScreen.init(store:)
//						)
//
//						CaseLet(
//							state: /RestoreWalletMethodState.Method.usingKeystore,
//							action: RestoreWalletMethodAction.usingKeystore,
//							then: RestoreWalletUsingKeystoreScreen.init(store:)
//						)
//
//					}
					
	
	                
					switch viewStore.method {
					case .usingKeystore:
						RestoreWalletUsingKeystoreScreen(
							store: self.store.scope(
								state: \.usingKeystore,
								action: RestoreWalletMethodAction.usingKeystore
							)
						)
					case .usingPrivateKey:
						RestoreWalletUsingPrivateKeyScreen(
							store: self.store.scope(
								state: \.usingPrivateKey,
								action: RestoreWalletMethodAction.usingPrivateKey
							)
						)
					}
	            }
	            .navigationTitle("Restore existing wallet")
			}
		}
    }
}
