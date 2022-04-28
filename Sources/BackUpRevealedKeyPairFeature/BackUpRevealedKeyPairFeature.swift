//
//  BackUpRevealedKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import ComposableArchitecture
import Common
import Screen
import Styleguide
import SwiftUI
import Wallet

public enum BackUpRevealedKeyPair {}

public extension BackUpRevealedKeyPair {
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public let keyPairHex: KeyPairHex
		public init(
			keyPairHex: KeyPairHex,
			alert: AlertState<Action>? = nil
		) {
			self.keyPairHex = keyPairHex
			self.alert = alert
		}
	}
}

public extension BackUpRevealedKeyPair {
	enum Action: Equatable {
		case `internal`(Internal)
		case delegate(Delegate)
	}
}

public extension BackUpRevealedKeyPair.Action {
	enum Internal: Equatable {
		case copyPublicKey
		case copyPrivateKey
		case done
		case alertDismissed
	}
}

public extension BackUpRevealedKeyPair.Action {
	enum Delegate: Equatable {
		case done
	}
}


public extension BackUpRevealedKeyPair {
	struct Environment {
		public init() {}
	}
}

public extension BackUpRevealedKeyPair {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case let .internal(internalAction):
			switch internalAction {
			case .done: return Effect(value: .delegate(.done))
			case .copyPrivateKey:
				guard copyToPasteboard(contents: state.keyPairHex.privateKey) else {
					return .none
				}
				state.alert = .init(title: TextState("Copied private key to pasteboard."))
				return .none
			case .copyPublicKey:
				guard copyToPasteboard(contents: state.keyPairHex.publicKey) else {
					return .none
				}
				state.alert = .init(title: TextState("Copied public key to pasteboard."))
				return .none
			case .alertDismissed:
				state.alert = nil
				return .none
			}
		case .delegate(_):
			return .none
		}
	}
}


// MARK: - BackUpRevealedKeyPairScreen
// MARK: -
public extension BackUpRevealedKeyPair {
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
public extension BackUpRevealedKeyPair.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: BackUpRevealedKeyPair.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack(alignment: .leading, spacing: 16) {
					Text("Private key")
						.font(.zhip.title)
						.foregroundColor(.white)
					
					Text("\(viewStore.displayablePrivateKey)")
						.font(.zhip.body)
						.textSelection(.enabled)
						.foregroundColor(.white)
					
					Button("Copy") {
						viewStore.send(.copyPrivateKeyButtonTapped)
					}
					.buttonStyle(.hollow)
					
					Text("Public key (Uncompressed)")
						.font(.zhip.title)
						.foregroundColor(.white)
					
					Text("\(viewStore.displayablePublicKey)")
						.font(.zhip.body)
						.textSelection(.enabled)
						.foregroundColor(.white)
					
					Button("Copy") {
						viewStore.send(.copyPublicKeyButtonTapped)
					}
					.buttonStyle(.hollow)
					
					Spacer()
				}
		
			}
			.alert(store.scope(state: \.alert), dismiss: .internal(.alertDismissed))
			.navigationTitle("Back up keys")
			.toolbar {
				Button("Done") {
					viewStore.send(.doneButtonTapped)
				}
			}
		}
	}
}

private extension BackUpRevealedKeyPair.Screen {
	struct ViewState: Equatable {
		let displayablePublicKey: String
		let displayablePrivateKey: String
		init(state: BackUpRevealedKeyPair.State) {
			self.displayablePublicKey = state.keyPairHex.publicKey
			self.displayablePrivateKey = state.keyPairHex.privateKey
		}
	}
	enum ViewAction: Equatable {
		case alertDismissed
		case doneButtonTapped
		case copyPublicKeyButtonTapped
		case copyPrivateKeyButtonTapped
	}
	
}

private extension BackUpRevealedKeyPair.Action {
	init(action: BackUpRevealedKeyPair.Screen.ViewAction) {
		switch action {
		case .copyPublicKeyButtonTapped:
			self = .internal(.copyPublicKey)
		case .copyPrivateKeyButtonTapped:
			self = .internal(.copyPrivateKey)
		case .doneButtonTapped:
			self = .internal(.done)
		case .alertDismissed:
			self = .internal(.alertDismissed)
		}
		
	}
}
