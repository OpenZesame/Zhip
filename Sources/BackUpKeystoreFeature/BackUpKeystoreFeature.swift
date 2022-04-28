//
//  RevealKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Combine
import Common
import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI
import Wallet

public enum BackUpKeystore {}

public extension BackUpKeystore {
	struct State: Equatable {
		public let wallet: Wallet
		public var alert: AlertState<Action>?
		public var displayableKeystore: String?
		public init(
			wallet: Wallet,
			alert: AlertState<Action>? = nil,
			displayableKeystore: String? = nil
		) {
			self.wallet = wallet
			self.alert = alert
			self.displayableKeystore = displayableKeystore
		}
	}
}

public extension BackUpKeystore {
	enum Action: Equatable {
		case `internal`(Internal)
		case delegate(Delegate)
	}
}

public extension BackUpKeystore.Action {
	
	enum Delegate: Equatable {
		case done
	}
	
	enum Internal: Equatable {
		case copyKeystore
		case done
		case loadKeystore
		case loadedKeystoreResult(Result<String, Never>)
		case alertDismissed
	}
}

public extension BackUpKeystore {
	struct Environment {
		public init(
		) {
		}
	}
}

public extension BackUpKeystore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .internal(.alertDismissed):
			state.alert = nil
			return .none
		case .internal(.loadKeystore):
			return state.wallet.exportKeystoreToJSON().catchToEffect {
				Action.internal(.loadedKeystoreResult($0))
			}
		case let .internal(.loadedKeystoreResult(.success(keystoreJSON))):
			state.displayableKeystore = keystoreJSON
			return .none
		case let .internal(.loadedKeystoreResult(.failure(error))):
			fatalError("\(error)")
		case .internal(.done):
			return Effect(value: .delegate(.done))
		case .internal(.copyKeystore):
			guard
				let keystoreJSON = state.displayableKeystore,
				copyToPasteboard(contents: keystoreJSON)
			else {
				return .none
			}
			state.alert = .init(title: TextState("Copied keystore to pasteboard."))
			return .none
		case .delegate(_):
			return .none
		}
	}
}



// MARK: - BackUpKeystoreScreen
// MARK: -

public extension BackUpKeystore {
	struct View: SwiftUI.View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension BackUpKeystore.View {
	var body: some SwiftUI.View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: BackUpKeystore.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					ScrollView {
						if let displayableKeystore = viewStore.displayableKeystore {
							Text(displayableKeystore)
								.textSelection(.enabled)
						}
					}
					Button("Copy keystore") {
						viewStore.send(.copyKeystoreButtonTapped)
					}
					.buttonStyle(.primary)
				}
			}
			.alert(store.scope(state: \.alert), dismiss: .internal(.alertDismissed))
			.onAppear { viewStore.send(.onAppear) }
			.navigationTitle("Back up keystore")
			.toolbar {
				Button("Done") {
					viewStore.send(.doneButtonTapped)
				}
			}
		}
	}
}


private extension BackUpKeystore.View {
	struct ViewState: Equatable {
		
		let displayableKeystore: String?
		
		init(state: BackUpKeystore.State) {
			self.displayableKeystore = state.displayableKeystore
		}
	}
	
	enum ViewAction: Equatable {
		case doneButtonTapped
		case copyKeystoreButtonTapped
		case onAppear
	}
}

private extension BackUpKeystore.Action {
	init(action: BackUpKeystore.View.ViewAction) {
		switch action {
		case .copyKeystoreButtonTapped:
			self = .internal(.copyKeystore)
		case .doneButtonTapped:
			self = .internal(.done)
		case .onAppear:
			self = .internal(.loadKeystore)
		}
	}
}
