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

public enum Balances {}

public extension Balances {
	struct State: Equatable {
		public let wallet: Wallet
		public init(wallet: Wallet) {
			self.wallet = wallet
		}
	}
}

public extension Balances {
	enum Action: Equatable {
		case delegate(Delegate)
	}
}
public extension Balances.Action {
	enum Delegate {
		case noop
	}
}
public extension Balances {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension Balances {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .delegate(.noop):
			return .none
		}
	}
}
public extension Balances {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension Balances.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			AuroraView {
				VStack {
					Text("Balances")
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
			.background(Color.appBackground)
		}
	}
}
