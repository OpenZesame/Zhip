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

public enum Receive {}

public extension Receive {
	struct State: Equatable {
		public let wallet: Wallet
		public init(wallet: Wallet) {
			self.wallet = wallet
		}
	}
}

public extension Receive {
	enum Action: Equatable {
		case delegate(Delegate)
	}
}

public extension Receive.Action {
	enum Delegate {
		case noop
	}
}

public extension Receive {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension Receive {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .delegate(.noop):
			return .none
		}
	}
}

public extension Receive {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension Receive.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack {
					Text("Receive")
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
			.navigationTitle("Receive")
		}
	}
}
