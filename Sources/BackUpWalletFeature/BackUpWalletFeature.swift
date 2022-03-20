//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpPrivateKeyAndKeystoreFeature
import ComposableArchitecture
import SwiftUI
import Wallet

public struct BackUpWalletState: Equatable {
	
	public enum Step: Equatable {
		case step1_BackUpPrivateKeyAndKeystore
		case step2a_BackUpPrivateKeyFlow
		case step2b_BackUpKeystore
	}
	
	public var wallet: Wallet
	public var step: Step
	public var backUpPrivateKeyAndKeystore: BackUpPrivateKeyAndKeystoreState
	
	public init(
		wallet: Wallet,
		step: Step = .step1_BackUpPrivateKeyAndKeystore,
		backUpPrivateKeyAndKeystore: BackUpPrivateKeyAndKeystoreState = .init()
	) {
		self.wallet = wallet
		self.step = step
		self.backUpPrivateKeyAndKeystore = backUpPrivateKeyAndKeystore
	}
}

public enum BackUpWalletAction: Equatable {
	case delegate(DelegateAction)
}
public extension BackUpWalletAction {
	enum DelegateAction: Equatable {
		case finishedBackingUpWallet(Wallet)
	}
}

public struct BackUpWalletEnvironment {
	public init() {}
}

public let backUpWalletReducer = Reducer<BackUpWalletState, BackUpWalletAction, BackUpWalletEnvironment> { state, action, environment in
	return .none
}

public struct BackUpWalletCoordinatorView: View {
	let store: Store<BackUpWalletState, BackUpWalletAction>
	
	public init(
		store: Store<BackUpWalletState, BackUpWalletAction>
	) {
		self.store = store
	}
}

public extension BackUpWalletCoordinatorView {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Group {
				Text("BackUpWalletCoordinatorView, wallet: \(viewStore.wallet.bech32Address.asString)")
			}
		}
	}
}

private extension BackUpWalletCoordinatorView {
	struct ViewState: Equatable {
		let wallet: Wallet
		init(state: BackUpWalletState) {
			self.wallet = state.wallet
		}
	}
}
