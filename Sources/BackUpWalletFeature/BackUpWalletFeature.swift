//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpPrivateKeyAndKeystoreFeature
import ComposableArchitecture
import Screen
import SwiftUI
import Wallet

public enum BackUpWallet {}

public extension BackUpWallet {
	enum Step: Equatable {
		case step1_BackUpPrivateKeyAndKeystore
		case step2a_BackUpPrivateKeyFlow
		case step2b_BackUpKeystore
	}
}

public extension BackUpWallet {
	struct State: Equatable {
		
		public var wallet: Wallet
		public var step: Step
		public var backUpPrivateKeyAndKeystore: BackUpPrivateKeyAndKeystore.State
		
		public init(
			wallet: Wallet,
			step: Step = .step1_BackUpPrivateKeyAndKeystore,
			backUpPrivateKeyAndKeystore: BackUpPrivateKeyAndKeystore.State = .init()
		) {
			self.wallet = wallet
			self.step = step
			self.backUpPrivateKeyAndKeystore = backUpPrivateKeyAndKeystore
		}
	}
}

public extension BackUpWallet {
	enum Action: Equatable {
		case delegate(Delegate)
	}
}
public extension BackUpWallet.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}

public extension BackUpWallet {
	struct Environment {
		public init() {}
	}
}

public extension BackUpWallet {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		return .none
	}
}

public extension BackUpWallet {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension BackUpWallet.CoordinatorScreen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Screen {
				VStack {
					Text("BackUpWalletCoordinatorView, wallet: \(viewStore.wallet.bech32Address.asString)")
					Button("I have backed up my wallet") {
						viewStore.send(.delegate(.finished(viewStore.wallet)))
					}
				}
			}
		}
	}
}

private extension BackUpWallet.CoordinatorScreen {
	struct ViewState: Equatable {
		let wallet: Wallet
		init(state: BackUpWallet.State) {
			self.wallet = state.wallet
		}
	}
}
