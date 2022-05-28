//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-05-01.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import TCACoordinators
import Zesame
import AmountFormatter

public enum BalanceRow {}

public extension BalanceRow {
	struct State: Equatable, Identifiable {
		public typealias ID = TokenBalance.ID
		public var id: ID { tokenBalance.id }
		
		public let tokenBalance: TokenBalance
		public init(
			tokenBalance: TokenBalance
		) {
			self.tokenBalance = tokenBalance
		}
		
		public static func zil(_ amount: Amount) -> Self {
			.init(tokenBalance: .zil(amount))
		}
		public static func gZil(_ amount: Amount) -> Self {
			.init(tokenBalance: .gZil(amount))
		}
		public static func xcad(_ amount: Amount) -> Self {
			.init(tokenBalance: .xcad(amount))
		}
		public static func zwap(_ amount: Amount) -> Self {
			.init(tokenBalance: .zwap(amount))
		}
		public static func xsgd(_ amount: Amount) -> Self {
			.init(tokenBalance: .xsgd(amount))
		}
	}
}

public extension BalanceRow {
	enum Action: Equatable {
		case didSelect
	}
}

public extension BalanceRow {
	struct Environment {
		
	}
}

public extension BalanceRow {
	typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

	static let reducer = Reducer { state, action, environment in
		switch action {
		default: break
		}
		return .none
	}
}

public extension BalanceRow {
	struct Screen: SwiftUI.View {
		public typealias Store = ComposableArchitecture.Store<State, Action>
		let store: Store
		public init(
			store: Store
		) {
			self.store = store
		}
	}
}

public extension BalanceRow.Screen {
	var body: some View {
        
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: BalanceRow.Action.init
			)
		) { viewStore in
			VStack(alignment: .leading, spacing: 8) {
				Text(viewStore.tokenSymbol)
					.font(viewStore.isZil ? .zhip.impression : .zhip.header)
				Text(viewStore.amount)
					.font(viewStore.isZil ? .zhip.callToAction : .zhip.body)
			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
			.onTapGesture {
				viewStore.send(.didSelect)
			}
			
		}
	}
}

internal extension BalanceRow.Screen {
	struct ViewState: Equatable {
		let isZil: Bool
		let amount: String
		let tokenSymbol: String
		init(state: BalanceRow.State) {
			self.isZil = state.tokenBalance.token == .zilling
			self.tokenSymbol = state.tokenBalance.token.symbol
			self.amount = AmountFormatter().format(
				amount: state.tokenBalance.amount,
				in: .zil,
				formatThousands: true,
				minFractionDigits: nil,
				showUnit: false
			)
		}
	}
	enum ViewAction: Equatable {
		case didSelect
	}
}

internal extension BalanceRow.Action {
	init(action: BalanceRow.Screen.ViewAction) {
		switch action {
		case .didSelect: self = .didSelect
		}
	}
}
