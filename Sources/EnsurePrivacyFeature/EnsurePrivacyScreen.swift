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

public struct EnsurePrivacyState: Equatable {
	public init() {}
}

public enum EnsurePrivacyAction: Equatable {
	
	case delegate(DelegateAction)
	
	case privacyIsEnsuredButtonTapped
	case screenMightBeWatchedButtonTapped
}
public extension EnsurePrivacyAction {
	enum DelegateAction: Equatable {
		case abort
		case proceed
	}
}

public struct EnsurePrivacyEnvironment {
	public init() {}
}

public let ensurePrivacyReducer = Reducer<EnsurePrivacyState, EnsurePrivacyAction, EnsurePrivacyEnvironment> {
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

// MARK: - EnsurePrivacyScreen
// MARK: -
public struct EnsurePrivacyScreen: View {
	let store: Store<EnsurePrivacyState, EnsurePrivacyAction>
	public init(store: Store<EnsurePrivacyState, EnsurePrivacyAction>) {
		self.store = store
	}
}

private extension EnsurePrivacyScreen {
	struct ViewState: Equatable {
		init(state: EnsurePrivacyState) {
			
		}
	}
}


// MARK: - View
// MARK: -
public extension EnsurePrivacyScreen {
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
