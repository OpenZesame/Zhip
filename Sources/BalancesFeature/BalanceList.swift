//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import Screen
import Styleguide
import Wallet

public enum BalanceList {}

public extension BalanceList {
	struct State: Equatable {
		public let wallet: Wallet
		public var balances: IdentifiedArrayOf<BalanceRow.State>
		
		public init(
			wallet: Wallet,
			balances: IdentifiedArrayOf<BalanceRow.State> = [
				.zil(4_321_000),
				.gZil(42),
				.xcad(237),
				.zwap(512),
				.xsgd(109),
			]
		) {
			self.wallet = wallet
			self.balances = balances
		}
	}
}

public extension BalanceList {
	enum Action: Equatable {
		case delegate(Delegate)
		case balance(id: TokenBalance.ID, action: BalanceRow.Action)
	}
}
public extension BalanceList.Action {
	enum Delegate: Equatable {
		case openDetailsFor(TokenBalance)
	}
	
}
public extension BalanceList {
	struct Environment {
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public init(
			mainQueue: AnySchedulerOf<DispatchQueue>
		) {
			self.mainQueue = mainQueue
		}
	}
}

public extension BalanceList {
	static let reducer = Reducer<State, Action, Environment>.combine(
		BalanceRow.reducer.forEach(
			state: \.balances,
			action: /BalanceList.Action.balance(id:action:),
			environment: { _ in BalanceRow.Environment.init() }
		),
		
		Reducer<State, Action, Environment> { state, action, environment in
			switch action {
            case let .balance(tokenBalanceID, tokenBalanceAction):
                switch tokenBalanceAction {
                case .didSelect:
                    let balance = state.balances.first(where: { $0.id == tokenBalanceID })!
                    return Effect(value: .delegate(.openDetailsFor(balance.tokenBalance)))
                }
            default: return .none
            }
        }
	)
}

public extension BalanceList {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension BalanceList.Screen {
	var body: some View {
		WithViewStore(store) { viewStore in
			AuroraView {
				VStack(alignment: .leading) {
					Text("Balances").font(.zhip.impression)
					// Why not use List?
					// Well as of 2022-02-28 we cannot really customize the appearance of
					// a List, especially background color, not the row views
					// (`UITableViewCell`). But everything just works using a `LazyVStack`
					// inside a `ScrollView`.
					ScrollView {
						LazyVStack(alignment: .leading, spacing: 0) {
							ForEachStore(
								store.scope(
									state: \.balances,
									action: BalanceList.Action.balance(id:action:)
								),
								content: BalanceRow.Screen.init(store:)
							)
							
						}
					}
				}
			}
			.background(Color.appBackground)
		}
	}
}
