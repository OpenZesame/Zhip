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

public enum TokenID: Hashable {
	case zilling
	case token(symbol: String, contractAddress: Bech32Address)
	
	public var symbol: String {
		switch self {
		case .zilling: return "Zil"
		case .token(let symbol, _):
			return symbol
		}
	}

	/// Governance Zilliqa
	public static let gZil = try! Self.token(
		symbol: "gZIL",
		contractAddress: Bech32Address(bech32String: "zil14pzuzq6v6pmmmrfjhczywguu0e97djepxt8g3e")
	)
	
	/// XCAD Network
	public static let xcad = try! Self.token(
		symbol: "XCAD",
		contractAddress: Bech32Address(bech32String: "zil1z5l74hwy3pc3pr3gdh3nqju4jlyp0dzkhq2f5y")
	)
	
	/// StraitsX Singapore Dollar
	public static let xsgd = try! Self.token(
		symbol: "XSGD",
		contractAddress: Bech32Address(bech32String: "zil1zu72vac254htqpg3mtywdcfm84l3dfd9qzww8t")
	)
	
	/// ZilSwap
	public static let zwap = try! Self.token(
		symbol: "ZWAP",
		contractAddress: Bech32Address(bech32String: "zil1p5suryq6q647usxczale29cu3336hhp376c627")
	)
}

public struct TokenBalance: Hashable, Identifiable {
	public typealias ID = TokenID

	public let amount: Amount
	public let token: TokenID
	public var id: ID { token }
	
	public static func zil(_ amount: Amount) -> Self {
		.init(amount: amount, token: .zilling)
	}
	public static func gZil(_ amount: Amount) -> Self {
		.init(amount: amount, token: .gZil)
	}
	public static func zwap(_ amount: Amount) -> Self {
		.init(amount: amount, token: .zwap)
	}
	public static func xsgd(_ amount: Amount) -> Self {
		.init(amount: amount, token: .xsgd)
	}
	public static func xcad(_ amount: Amount) -> Self {
		.init(amount: amount, token: .xcad)
	}
}

public enum BalanceOf {}

public extension BalanceOf {
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

public extension BalanceOf {
	enum Action: Equatable {
		case didSelect
	}
}

public extension BalanceOf {
	struct Environment {
		
	}
}

public extension BalanceOf {
	typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

	static let reducer = Reducer { state, action, environment in
		switch action {
		default: break
		}
		return .none
	}
}

public extension BalanceOf {
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

public extension BalanceOf.Screen {
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: BalanceOf.Action.init
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

internal extension BalanceOf.Screen {
	struct ViewState: Equatable {
		let isZil: Bool
		let amount: String
		let tokenSymbol: String
		init(state: BalanceOf.State) {
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

internal extension BalanceOf.Action {
	init(action: BalanceOf.Screen.ViewAction) {
		switch action {
		case .didSelect: self = .didSelect
		}
	}
}
