//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-09.
//

import ComposableArchitecture
import Styleguide
import SwiftUI
import Screen

public enum Welcome {}

public extension Welcome {
	struct State: Equatable {
		public init() {}
	}
}

public extension Welcome {
	enum Action: Equatable {
		case delegate(Delegate)
		case startButtonTapped
	}
}
public extension Welcome.Action {
	enum Delegate: Equatable {
		case getStarted
	}
}

public extension Welcome {
	struct Environment {
		public init() {}
	}
}

public extension Welcome {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .startButtonTapped:
			return Effect(value: .delegate(.getStarted))
		case .delegate(_):
			return .none
		}
		
	}
}

// MARK: - WelcomeScreen
// MARK: -
public extension Welcome {
	struct Screen: View {
		let store: Store<State, Action>
		
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}


// MARK: - View
// MARK: -
public extension Welcome.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			Screen {
				VStack {
					Spacer()
					
					Labels(
						title: "Welcome", font: .zhip.impression,
						subtitle: "Welcome to Zhip - the worlds first iOS wallet for Zilliqa."
					)
					
					Button("Start") {
						viewStore.send(.startButtonTapped)
					}
					.buttonStyle(.primary)
				}
				.padding()
				.background {
					ParallaxImage(
						back: "Images/Welcome/BackClouds",
						middle: "Images/Welcome/MiddleSpaceship",
						front: "Images/Welcome/FrontBlastOff"
					)
				}
			}
		}
	}
}
