//
//  NewWalletOrRestoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI

// MARK: - NewWalletOrRestore
// MARK: -

/// Screen for chosing between generating a new wallet or restoring an existing.
public enum NewWalletOrRestore {}

// MARK: - State
// MARK: -
public extension NewWalletOrRestore {
	struct State: Equatable {
		public init() {}
	}
}

// MARK: - Action
// MARK: -
public extension NewWalletOrRestore {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case newWalletButtonTapped
		case restoreWalletButtonTapped
	}
}

public extension NewWalletOrRestore.Action {
	enum Delegate: Equatable {
		case generateNewWallet
		case restoreWallet
	}
}

// MARK: - Environment
// MARK: -
public extension NewWalletOrRestore {
	struct Environment {
		public init() {}
	}
}


// MARK: - Reducer
// MARK: -
public extension NewWalletOrRestore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .delegate(_):
			return .none
		case .restoreWalletButtonTapped:
			return Effect(value: .delegate(.restoreWallet))
		case .newWalletButtonTapped:
			return Effect(value: .delegate(.generateNewWallet))
		}
	}
}

	// MARK: - Screen
	// MARK: -
public extension NewWalletOrRestore {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}



// MARK: - View Conf.
// MARK: -
public extension NewWalletOrRestore.Screen {
	var body: some View {
		WithViewStore(
			store
		) { viewStore in
			Screen {
				VStack {
					Spacer()
					
					Labels(
						title: "Wallet", font: .zhip.impression,
						subtitle: "It is time to set up the wallet. Do you want to start fresh, or restore an existing"
					)
					
					CallToAction(
						primary: {
							Button("Generate new") {
								viewStore.send(.newWalletButtonTapped)
							}
						},
						secondary: {
							Button("Restore existing") {
								viewStore.send(.restoreWalletButtonTapped)
							}
						}
					)
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
private extension NewWalletOrRestore.Screen {
    
    var backgroundView: some View {
        ParallaxImage(
            back: "Images/ChooseWallet/BackAbyss",
            middle: "Images/ChooseWallet/MiddleStars",
            front: "Images/ChooseWallet/FrontPlanets"
        )
    }
}
    

