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

public struct WelcomeState: Equatable {
	public init() {}
}

public enum WelcomeAction: Equatable {
	case delegate(DelegateAction)
	case startButtonTapped
}
public extension WelcomeAction {
	enum DelegateAction: Equatable {
		case getStarted
	}
}

public struct WelcomeEnvironment {
	public init() {}
}

public let welcomeReducer = Reducer<
	WelcomeState,
	WelcomeAction,
	WelcomeEnvironment
> { state, action, environment in
	switch action {
	case .startButtonTapped:
		return Effect(value: .delegate(.getStarted))
	case .delegate(_):
		return .none
	}
	
}

// MARK: - WelcomeScreen
// MARK: -
public struct WelcomeScreen: View {
	let store: Store<WelcomeState, WelcomeAction>
	
	public init(
		store: Store<WelcomeState, WelcomeAction>
	) {
		self.store = store
	}
}


// MARK: - View
// MARK: -
public extension WelcomeScreen {
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
