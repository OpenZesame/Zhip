//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import SwiftUI
import Wallet

public enum BackUpPrivateKey {}

public extension BackUpPrivateKey {
	struct State: Equatable {
		public init() {
			
		}
	}
}

public extension BackUpPrivateKey {
	enum Action: Equatable {
		
	}
}

public extension BackUpPrivateKey {
	struct Environment {
		public let wallet: Wallet
		public init(
			wallet: Wallet
		) {
			self.wallet = wallet
		}
	}
}

public extension BackUpPrivateKey {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		return .none
	}
}

public extension BackUpPrivateKey {
	struct View: SwiftUI.View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
		public var body: some SwiftUI.View {
			Text("BackUpPrivateKey VIEW")
				.font(.largeTitle)
				.foregroundColor(Color.white)
				.background(Color.green)
		}
	}
}
