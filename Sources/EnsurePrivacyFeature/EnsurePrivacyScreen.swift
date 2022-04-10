//
//  EnsurePrivacyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI

public enum EnsurePrivacy {}

public extension EnsurePrivacy {
	struct State: Equatable {
		public init() {}
	}
}

public extension EnsurePrivacy {
	enum Action: Equatable {
		
		case delegate(Delegate)
		
		case privacyIsEnsuredButtonTapped
		case screenMightBeWatchedButtonTapped
	}
}
public extension EnsurePrivacy.Action {
	enum Delegate: Equatable {
		case abort
		case proceed
	}
}

public extension EnsurePrivacy {
	struct Environment {
		public init() {}
	}
}

public extension EnsurePrivacy {
	static let reducer = Reducer<State, Action, Environment> {
		state, action, environment in
		switch action {
		case .delegate(_):
			return .none
		case .privacyIsEnsuredButtonTapped:
			return Effect(value: .delegate(.proceed))
		case .screenMightBeWatchedButtonTapped:
			return Effect(value: .delegate(.abort))
		}
	}
}

// MARK: - EnsurePrivacyScreen
// MARK: -
public extension EnsurePrivacy {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

private extension EnsurePrivacy.Screen {
	struct ViewState: Equatable {
		init(state: EnsurePrivacy.State) {
			
		}
	}
}


// MARK: - View
// MARK: -
public extension EnsurePrivacy.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack {
					Image("Icons/Large/Shield")
					
					Labels(
						title: "Security",
						subtitle: "Make sure ethat you are in a private space where no one can see/record your personal data. Avoid public places, cameras and CCTV's"
					)
					
					CallToAction(
						primary: {
							Button("My screen is not being watched") {
								viewStore.send(.privacyIsEnsuredButtonTapped)
							}
						},
						secondary: {
							Button("My screen might be watched") {
								viewStore.send(.screenMightBeWatchedButtonTapped)
							}
						}
					)
				}
			}
		}
	}
}
