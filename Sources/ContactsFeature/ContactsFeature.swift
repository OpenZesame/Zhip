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

public enum Contacts {}

public extension Contacts {
	struct State: Equatable {
		public init() {}
	}
}

public extension Contacts {
	enum Action: Equatable {
		case delegate(Delegate)
	}
}
public extension Contacts.Action {
	enum Delegate: Equatable {
		case noop
	}
}

public extension Contacts {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension Contacts {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .delegate(_):
			return .none
		}
	}
}

public extension Contacts {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension Contacts.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Contacts")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Contacts")
		}
	}
}
