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
//	case delegate(DelegateAction)
	case startButtonTapped
}
//public extension WelcomeAction {
//	enum DelegateAction {
//		case getStarted
//	}
//}


// MARK: - WelcomeScreen
// MARK: -
public struct WelcomeScreen: View {
	let store: Store<WelcomeState, WelcomeAction>
//	@ObservedObject var viewStore: ViewStore<Void, WelcomeAction>
	
	public init(
		store: Store<WelcomeState, WelcomeAction>
	) {
		self.store = store
//		self.viewStore = .init(store)
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
					backgroundView
				}
			}
		}
	}
}

// MARK: - Subviews
// MARK: -
private extension WelcomeScreen {
	
	
	var backgroundView: some View {
		ParallaxImage(
			back: "Images/Welcome/BackClouds",
			middle: "Images/Welcome/MiddleSpaceship",
			front: "Images/Welcome/FrontBlastOff"
		)
	}
}
