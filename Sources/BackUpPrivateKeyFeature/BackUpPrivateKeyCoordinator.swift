//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpRevealedKeyPairFeature
import ComposableArchitecture
import DecryptKeystoreFeature
import SwiftUI
import TCACoordinators
import Wallet

public enum BackUpPrivateKey {}

public extension BackUpPrivateKey {
	struct Environment {
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
		}
	}
}


public extension BackUpPrivateKey {
	enum Screen {}
}

public extension BackUpPrivateKey.Screen {
	enum State: Equatable {
		case decryptKeystore(DecryptKeystore.State)
		case backUpRevealedKeyPair(BackUpRevealedKeyPair.State)
	}
}

public extension BackUpPrivateKey.Screen {
	enum Action: Equatable {
		case decryptKeystore(DecryptKeystore.Action)
		case backUpRevealedKeyPair(BackUpRevealedKeyPair.Action)
	}
}


public extension BackUpPrivateKey.Screen {
	static let reducer = Reducer<State, Action, BackUpPrivateKey.Environment>.combine(
		DecryptKeystore.reducer
			.pullback(
				state: /State.decryptKeystore,
				action: /Action.decryptKeystore,
				environment: {
					DecryptKeystore.Environment(
						backgroundQueue: $0.backgroundQueue,
						mainQueue: $0.mainQueue
					)
				}
			),
		
		BackUpRevealedKeyPair.reducer
			.pullback(
				state: /State.backUpRevealedKeyPair,
				action: /Action.backUpRevealedKeyPair,
				environment: { _ in
					BackUpRevealedKeyPair.Environment()
				}
			),
		
		Reducer { state, action, environment in
			return .none
		}
	)
}

public extension BackUpPrivateKey {
	enum Coordinator {}
}

public extension BackUpPrivateKey.Coordinator {
	typealias Routes = [Route<BackUpPrivateKey.Screen.State>]
	struct State: Equatable, IndexedRouterState {
		
		public static func initialState(wallet: Wallet) -> Self {
			Self(routes: [
				.root(.decryptKeystore(.init(wallet: wallet)))
			])
		}
		
		public var routes: Routes
		
		public init(
			routes: Routes
		) {
			self.routes = routes
		}
		
	}
}

public extension BackUpPrivateKey.Coordinator {
	enum Action: Equatable, IndexedRouterAction {
		case routeAction(Int, action: BackUpPrivateKey.Screen.Action)
		case updateRoutes(Routes)
		case delegate(Delegate)
	}
}
public extension BackUpPrivateKey.Coordinator.Action {
	enum Delegate: Equatable {
		case done
	}
}

public extension BackUpPrivateKey.Coordinator {
	typealias Reducer = ComposableArchitecture.Reducer<State, Action, BackUpPrivateKey.Environment>
	static let coordinatorReducer: Reducer = BackUpPrivateKey.Screen.reducer
		.forEachIndexedRoute(
			environment: {
				BackUpPrivateKey.Environment(
					backgroundQueue: $0.backgroundQueue,
					mainQueue: $0.mainQueue
				)
			}
		)
		.withRouteReducer(
			Reducer { state, action, environment in
				switch action {
				case let .routeAction(_, .decryptKeystore(.delegate(.decryptedKeyPair(keyPairHex)))):
					state.routes.push(.backUpRevealedKeyPair(.init(keyPairHex: keyPairHex)))
				case .routeAction(_, .backUpRevealedKeyPair(.delegate(.done))):
					return Effect(value: .delegate(.done))
				default:
					break
				}
				return .none
			}
		)
}

public extension BackUpPrivateKey.Coordinator {
	struct View: SwiftUI.View {
		public typealias Store = ComposableArchitecture.Store<State, Action>
		let store: Store
		public init(store: Store) {
			self.store = store
		}
		public var body: some SwiftUI.View {
			TCARouter(store) { screen in
				SwitchStore(screen) {
					CaseLet(
						state: /BackUpPrivateKey.Screen.State.decryptKeystore,
						action: BackUpPrivateKey.Screen.Action.decryptKeystore,
						then: DecryptKeystore.Screen.init
					)
					CaseLet(
						state: /BackUpPrivateKey.Screen.State.backUpRevealedKeyPair,
						action: BackUpPrivateKey.Screen.Action.backUpRevealedKeyPair,
						then: BackUpRevealedKeyPair.Screen.init
					)
				}
			}
		}
	}
}
