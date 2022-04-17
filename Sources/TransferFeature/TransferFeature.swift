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

public struct Reciept: Hashable {}

public enum Transfer {}

public extension Transfer {
	struct State: Equatable {
		public let wallet: Wallet
		public init(wallet: Wallet) {
			self.wallet = wallet
		}
	}
}
public extension Transfer {
	enum Action: Equatable {
		case delegate(Delegate)
	}
}

public extension Transfer.Action {
	enum Delegate: Equatable {
		case transactionFinalized(Reciept)
		case transactionBroadcastedButSkippedWaitingForFinalization(txID: String)
	}
}

public extension Transfer {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension Transfer {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .delegate(_):
			return .none
		}
	}
}

public extension Transfer {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension Transfer.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Text("Transfer")
						.font(.zhip.bigBang)
						.foregroundColor(.turquoise)
					Text(viewStore.wallet.address(.mainnet))
						.font(.zhip.title)
						.foregroundColor(.turquoise)
						.textSelection(.enabled)
					Text(viewStore.wallet.address(.legacy))
						.font(.zhip.title)
						.foregroundColor(.turquoise)
						.textSelection(.enabled)
				}
			}
			.navigationTitle("Transfer")
		}
	}
}
