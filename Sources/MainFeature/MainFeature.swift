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

public struct MainState: Equatable {
	

	public var unlockApp: UnlockAppState?
	public var tabs: TabsState
	
	public init(
		wallet: Wallet,
		maybePIN pin: Pincode? = nil
	) {
		self.unlockApp = pin.map { .init(role: .unlockApp, expectedPIN: $0) }
		self.tabs = .init(wallet: wallet)
	}
}

public enum MainAction: Equatable {
	case delegate(DelegateAction)

	case lockApp
	
	case unlockApp(UnlockAppAction)
	case tabs(TabsAction)
}
public extension MainAction {
	enum DelegateAction: Equatable {
		case userDeletedWallet
	}
}

public struct MainEnvironment {
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

public let mainReducer = Reducer<MainState, MainAction, MainEnvironment>.combine(
	unlockAppReducer
		.optional()
		.pullback(
			state: \.unlockApp,
			action: /MainAction.unlockApp,
			environment: {
				UnlockAppEnvironment(keychainClient: $0.keychainClient)
			}
	),
	
	tabsReducer.pullback(
		state: \.tabs,
		action: /MainAction.tabs,
		environment: {
			TabsEnvironment(
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

public struct MainCoordinatorView: View {
	let store: Store<MainState, MainAction>
	public init(
		store: Store<MainState, MainAction>
	) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(store.scope(state: ViewState.init)) { viewStore in
			
			/*
			 if viewStore.isSplashPresented {
				 IfLetStore(
					 store.scope(
						 state: \.splash,
						 action: AppAction.splash
					 ),
					 then: SplashView.init(store:)
				 )
				 .zIndex(3)
			 } else if viewStore.isOnboardingPresented {
				 IfLetStore(
					 store.scope(
						 state: \.onboarding,
						 action: AppAction.onboarding
					 ),
					 then: OnboardingCoordinatorView.init(store:)
				 )
				 .zIndex(2)*/
			
			Group {
				if viewStore.isPresentingUnlockScreen {
					IfLetStore(
						store.scope(
							state: \.unlockApp,
							action: MainAction.unlockApp
						),
						then: UnlockAppWithPINScreen.init(store:)
					)
					.zIndex(0)
				} else {
					TabsCoordinatorView(
						store: store.scope(
							state: \.tabs,
							action: MainAction.tabs
						)
					).zIndex(-1)
				}
			}
		}
	}
}

private extension MainCoordinatorView {
	struct ViewState: Equatable {
		var isPresentingUnlockScreen: Bool
		init(state: MainState) {
			self.isPresentingUnlockScreen = state.unlockApp != nil
		}
	}
}
