//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import PINCode
import SwiftUI
import TabsFeature
import UnlockAppFeature
import UserDefaultsClient
import Wallet

public enum Main {}

public extension Main {
	struct State: Equatable {
		
		
		public var wallet: Wallet
		public var pin: Pincode?
		
		public var unlockApp: UnlockApp.State?
		public var tabs: Tabs.State
		
		public init(
			wallet: Wallet,
			maybePIN pin: Pincode? = nil,
			promptUserToUnlockAppIfNeeded: Bool = true
		) {
			self.wallet = wallet
			self.pin = pin
			self.unlockApp = promptUserToUnlockAppIfNeeded ? pin.map { .init(role: .unlockApp, expectedPIN: $0) } : nil
			self.tabs = .init(wallet: wallet, isPINSet: pin != nil)
		}
	}
}

public extension Main {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case lockApp
		
		case unlockApp(UnlockApp.Action)
		case tabs(Tabs.Action)
	}
}
public extension Main.Action {
	enum Delegate: Equatable {
		case userDeletedWallet
	}
}

public extension Main {
	struct Environment {
		public var userDefaults: UserDefaultsClient
		public var keychainClient: KeychainClient
		public var mainQueue: AnySchedulerOf<DispatchQueue>
		
		public init(
			userDefaults: UserDefaultsClient,
			keychainClient: KeychainClient,
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.userDefaults = userDefaults
			self.keychainClient = keychainClient
			self.mainQueue = mainQueue
		}
	}
}

public extension Main {
	static let reducer = Reducer<State, Action, Environment>.combine(
		UnlockApp.reducer
			.optional()
			.pullback(
				state: \.unlockApp,
				action: /Main.Action.unlockApp,
				environment: {
					UnlockApp.Environment(mainQueue: $0.mainQueue)
				}
			),
		
		Tabs.reducer.pullback(
			state: \.tabs,
			action: /Main.Action.tabs,
			environment: {
				Tabs.Environment(
					userDefaults: $0.userDefaults,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue
				)
			}
		),
		
		Reducer { state, action, environment in
			switch action {
				
			case .lockApp:
				fatalError()
				
			case .unlockApp(.delegate(.userUnlockedApp)):
				state.unlockApp = nil
				return .none
			case .unlockApp(.delegate(.userCancelled)):
				state.unlockApp = nil
				return .none
			case .unlockApp(_):
				return .none
				
			case .tabs(.delegate(.userDeletedWallet)):
				return Effect(value: .delegate(.userDeletedWallet))
			case .tabs(_):
				return .none
				
			case .delegate(_):
				return .none
			}
		}
	)
}

public extension Main {
	struct CoordinatorScreen: View {
		
		let store: Store<State, Action>
		
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension Main.CoordinatorScreen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Group {
				if viewStore.isPresentingUnlockScreen {
					IfLetStore(
						store.scope(
							state: \.unlockApp,
							action: Main.Action.unlockApp
						),
						then: UnlockApp.Screen.init(store:)
					)
					.zIndex(0)
				} else {
					Tabs.CoordinatorScreen(
						store: store.scope(
							state: \.tabs,
							action: Main.Action.tabs
						)
					).zIndex(-1)
				}
			}
		}
	}
}

private extension Main.CoordinatorScreen {
	struct ViewState: Equatable {
		var isPresentingUnlockScreen: Bool
		init(state: Main.State) {
			self.isPresentingUnlockScreen = state.unlockApp != nil
		}
	}
}
