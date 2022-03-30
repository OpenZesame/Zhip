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

public struct TransferState: Equatable {
	public let wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}
public enum TransferAction: Equatable {}
public struct TransferEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let transferReducer = Reducer<TransferState, TransferAction, TransferEnvironment> { state, action, environment in
	switch action {
	}
	return .none
}

public struct TransferView: View {
	let store: Store<TransferState, TransferAction>
	public init(
		store: Store<TransferState, TransferAction>
	) {
		self.store = store
	}
}

public extension TransferView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Text("Transfer")
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
			.navigationTitle("Transfer")
		}
	}
}
