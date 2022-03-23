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

public struct ReceiveState: Equatable {
	public let wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}
public enum ReceiveAction: Equatable {}
public struct ReceiveEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let receiveReducer = Reducer<ReceiveState, ReceiveAction, ReceiveEnvironment> { state, action, environment in
	switch action {
	}
	return .none
}

public struct ReceiveView: View {
	let store: Store<ReceiveState, ReceiveAction>
	public init(
		store: Store<ReceiveState, ReceiveAction>
	) {
		self.store = store
	}
}

public extension ReceiveView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Receive")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Receive")
		}
	}
}
