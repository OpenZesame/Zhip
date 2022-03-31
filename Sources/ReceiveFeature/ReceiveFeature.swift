//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import Screen
import Styleguide
import Wallet

public struct ReceiveState: Equatable {
	public let wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}
public enum ReceiveAction: Equatable {
	case delegate(DelegateAction)
}
public extension ReceiveAction {
	enum DelegateAction {
		case noop
	}
}
public struct ReceiveEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let receiveReducer = Reducer<ReceiveState, ReceiveAction, ReceiveEnvironment> { state, action, environment in
	switch action {
	case .delegate(.noop):
		return .none
	}
}

public struct ReceiveView: View {
	let store: Store<ReceiveState, ReceiveAction>
	public init(
		store: Store<ReceiveState, ReceiveAction>
	) {
		self.store = store
	}
}

public extension ReceiveView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Text("Receive")
						.font(.zhip.bigBang)
						.foregroundColor(.turquoise)
					Text(viewStore.wallet.bech32Address.asString)
						.font(.zhip.title)
						.foregroundColor(.turquoise)
						.textSelection(.enabled)
					Text(viewStore.wallet.legacyAddress.asString)
						.font(.zhip.title)
						.foregroundColor(.turquoise)
						.textSelection(.enabled)
				}
			}
			.navigationTitle("Receive")
		}
	}
}
