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

public struct BalancesState: Equatable {
	public let wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}
public enum BalancesAction: Equatable {}
public struct BalancesEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let balancesReducer = Reducer<BalancesState, BalancesAction, BalancesEnvironment> { state, action, environment in
	switch action {
	}
	return .none
}

public struct BalancesView: View {
	let store: Store<BalancesState, BalancesAction>
	public init(
		store: Store<BalancesState, BalancesAction>
	) {
		self.store = store
	}
}

public extension BalancesView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Balances")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Balances")
		}
	}
}
