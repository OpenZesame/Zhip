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

public struct NewWalletOrRestoreState: Equatable {
	public init() {}
}

public enum NewWalletOrRestoreAction: Equatable {
	case newWalletButtonTapped
	case restoreWalletButtonTapped
	case delegate(DelegateAction)
}
public extension NewWalletOrRestoreAction {
	enum DelegateAction: Equatable {
		case generateNewWallet
		case restoreWallet
	}
}

public struct NewWalletOrRestoreEnvironment {
	public init() {}
}

public let newWalletOrRestoreReducer = Reducer<NewWalletOrRestoreState, NewWalletOrRestoreAction, NewWalletOrRestoreEnvironment> { state, action, environment in
	switch action {
	case .delegate(_):
		return .none
	case .restoreWalletButtonTapped:
		return Effect(value: .delegate(.restoreWallet))
	case .newWalletButtonTapped:
		return Effect(value: .delegate(.generateNewWallet))
	}
}

// MARK: - NewWalletOrRestoreScreen
// MARK: -
public struct NewWalletOrRestoreScreen: View {
	let store: Store<NewWalletOrRestoreState, NewWalletOrRestoreAction>
	public init(store: Store<NewWalletOrRestoreState, NewWalletOrRestoreAction>) {
		self.store = store
	}
}

private extension NewWalletOrRestoreScreen {
	struct ViewState: Equatable {
		init(state: NewWalletOrRestoreState) {
		}
	}
}

// MARK: - View
// MARK: -
public extension NewWalletOrRestoreScreen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init
			)
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
private extension NewWalletOrRestoreScreen {
    
    var backgroundView: some View {
        ParallaxImage(
            back: "Images/ChooseWallet/BackAbyss",
            middle: "Images/ChooseWallet/MiddleStars",
            front: "Images/ChooseWallet/FrontPlanets"
        )
    }
}
    

