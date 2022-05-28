//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-05-01.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import TCACoordinators
import Wallet

public enum BalancesCoordinator {}

public extension BalancesCoordinator {
	enum ScreenState: Equatable {
		case list(BalanceList.State)
		case detail(BalanceOf.State)
	}
	enum ScreenAction: Equatable {
		case list(BalanceList.Action)
		case detail(BalanceOf.Action)
	}
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
	
	typealias Routes = [Route<BalancesCoordinator.ScreenState>]
	struct State: IndexedRouterState, Equatable {
		public var routes: Routes

		public static func initialState(wallet: Wallet) -> Self {
			.init(routes: [
				.root(.list(.init(wallet: wallet)))
			])
		}
	}
	enum Action: IndexedRouterAction, Equatable {
		case updateRoutes(Routes)
		case routeAction(Int, action: ScreenAction)
		
		case delegate(Delegate)
		public enum Delegate: Equatable {
			case noop
		}
	}
	
	
	static let screenReducer = Reducer<ScreenState, ScreenAction, Environment>.combine(
		BalanceList.reducer.pullback(
			state: /ScreenState.list,
			action: /ScreenAction.list,
			environment: {
				BalanceList.Environment(
					mainQueue: $0.mainQueue
				)
			})
	)
	
	static let coordinatorReducer: Reducer<State, Action, Environment> = screenReducer
		.forEachIndexedRoute(environment: {
			Environment(mainQueue: $0.mainQueue)
		})
		.withRouteReducer(
			Reducer { state, action, environment in
				switch action {
				case let .routeAction(_, action: .list(.delegate(BalanceList.Action.Delegate.openDetailsFor(tokenBalance)))):
					print("✨ should open details for: \(tokenBalance)")
					break
				default: break
				}
				return .none
			}
		)
	
	struct View: SwiftUI.View {
		public typealias Store = ComposableArchitecture.Store<State, Action>
		let store: Store
		public init(
			store: Store
		) {
			self.store = store
		}
		
		public var body: some SwiftUI.View {
			TCARouter(store) { screen in
				SwitchStore(screen) {
					CaseLet(
						state: /BalancesCoordinator.ScreenState.list,
						action: BalancesCoordinator.ScreenAction.list,
						then: BalanceList.Screen.init
					)
					CaseLet(
						state: /BalancesCoordinator.ScreenState.detail,
						action: BalancesCoordinator.ScreenAction.detail,
						then: BalanceOf.Screen.init
					)
				}
			}
		}
	}
}
