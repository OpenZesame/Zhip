//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpPrivateKeyFeature
import BackUpPrivateKeyAndKeystoreFeature
import BackUpKeystoreFeature

import ComposableArchitecture
import Screen
import SwiftUI
import TCACoordinators
import Wallet

// MARK: Namespace

/// Back up wallet flow, guides the user through components that ensure her new
/// wallet gets back up by the user.
public enum BackUpWallet {}

public extension BackUpWallet {
	enum Screen {}
}

public extension BackUpWallet.Screen {
	/// Components of the back up wallet flow, a component can either be a
	/// single screen or a subflow consisting of multiple screens.
	enum State: Equatable {
		case step1_BackUpPrivateKeyAndKeystore(BackUpPrivateKeyAndKeystore.State)
		case step2a_BackUpPrivateKey(BackUpPrivateKey.Coordinator.State)
		case step2b_BackUpKeystore(BackUpKeystore.State)
	}
}

public extension BackUpWallet.Screen {
	
	/// Actions from the back up wallet flow.
	enum Action: Equatable {
		case step1_BackUpPrivateKeyAndKeystore(BackUpPrivateKeyAndKeystore.Action)
		case step2a_BackUpPrivateKey(BackUpPrivateKey.Coordinator.Action)
		case step2b_BackUpKeystore(BackUpKeystore.Action)
	}
}

public extension BackUpWallet {
	struct Environment {
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let wallet: Wallet
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			wallet: Wallet
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
			self.wallet = wallet
		}
	}
}

public extension BackUpWallet.Screen {
	static let reducer = Reducer<State, Action, BackUpWallet.Environment>.combine(
		BackUpPrivateKeyAndKeystore.reducer
			.pullback(
				state: /State.step1_BackUpPrivateKeyAndKeystore,
				action: /Action.step1_BackUpPrivateKeyAndKeystore,
				environment: { BackUpPrivateKeyAndKeystore.Environment(wallet: $0.wallet) }
			),
		
		BackUpPrivateKey.Coordinator.coordinatorReducer
			.pullback(
				state: /State.step2a_BackUpPrivateKey,
				action: /Action.step2a_BackUpPrivateKey,
				environment: {
					BackUpPrivateKey.Environment(
						backgroundQueue: $0.backgroundQueue,
						mainQueue: $0.mainQueue,
						wallet: $0.wallet
					)
				}
			),
		
		BackUpKeystore.reducer
			.pullback(
				state: /State.step2b_BackUpKeystore,
				action: /Action.step2b_BackUpKeystore,
				environment: { BackUpKeystore.Environment(wallet: $0.wallet) }
			),

		
		Reducer { state, action, environment in
			return .none
		}
	)
	.debug()
}

public extension BackUpWallet {
	enum Coordinator {}
}

public extension BackUpWallet.Coordinator {
	typealias Routes = [Route<BackUpWallet.Screen.State>]
	struct State: Equatable, IndexedRouterState {
		public var routes: Routes
		
		public init(
			routes: Routes
		) {
			self.routes = routes
		}
		
		public static let fromSettings = Self(
			routes: [
				.root(
					.step1_BackUpPrivateKeyAndKeystore(
						.init(mode: .userInitiatedFromSettings)
					)
				)
			]
		)
		
		public static let fromOnboarding = Self(
			routes: [
				.root(
					.step1_BackUpPrivateKeyAndKeystore(
						.init(mode: .mandatoryBackUpPartOfOnboarding)
					)
				)
			]
		)
		
	}
}

public extension BackUpWallet.Coordinator {
	enum Action: Equatable, IndexedRouterAction {
		case routeAction(Int, action: BackUpWallet.Screen.Action)
		case updateRoutes(Routes)
		
		case delegate(Delegate)
	}
}
public extension BackUpWallet.Coordinator.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}

public extension BackUpWallet.Coordinator {
	static let reducer: Reducer<State, Action, BackUpWallet.Environment> = BackUpWallet.Screen.reducer
		.forEachIndexedRoute(environment: { $0 })
		.withRouteReducer(
			Reducer { state, action, environment in
				switch action {
				case let .routeAction(_, routeAction):
					switch routeAction {
					case let .step1_BackUpPrivateKeyAndKeystore(.delegate(delegateAction)):
						switch delegateAction {
						
						case .finishedBackingUpWallet:
							return Effect(value: .delegate(.finished(environment.wallet)))
							
						case .revealPrivateKey:
							let screen: BackUpWallet.Screen.State = .step2a_BackUpPrivateKey(.initialState)
							state.routes.presentSheet(screen, embedInNavigationView: true, onDismiss: nil)
							
						case .revealKeystore:
							let screen: BackUpWallet.Screen.State = .step2b_BackUpKeystore(.init())
							state.routes.presentSheet(screen, embedInNavigationView: true, onDismiss: nil)
						
						}
						
					case .step2a_BackUpPrivateKey(.delegate(.done)):
						_ = state.routes.popLast()
						
					case .step2b_BackUpKeystore(.delegate(.done)):
						_ = state.routes.popLast()
				
					default: break
					}
				default: break
				}
				return .none
			}
		)
}

public extension BackUpWallet.Coordinator {
	typealias Store = ComposableArchitecture.Store<BackUpWallet.Coordinator.State, BackUpWallet.Coordinator.Action>
	struct View: SwiftUI.View {
		let store: Store
		
		public init(
			store: Store
		) {
			self.store = store
		}
	}
}

public extension BackUpWallet.Coordinator.View {
	var body: some View {
		TCARouter(store) { screen in
			SwitchStore(screen) {
				CaseLet(
					state: /BackUpWallet.Screen.State.step1_BackUpPrivateKeyAndKeystore,
					action: BackUpWallet.Screen.Action.step1_BackUpPrivateKeyAndKeystore,
					then: BackUpPrivateKeyAndKeystore.Screen.init
				)
				CaseLet(
					state: /BackUpWallet.Screen.State.step2a_BackUpPrivateKey,
					action: BackUpWallet.Screen.Action.step2a_BackUpPrivateKey,
					then: BackUpPrivateKey.Coordinator.View.init
				)
				CaseLet(
					state: /BackUpWallet.Screen.State.step2b_BackUpKeystore,
					action: BackUpWallet.Screen.Action.step2b_BackUpKeystore,
					then: BackUpKeystore.View.init
				)
			}
		}
	}
}
