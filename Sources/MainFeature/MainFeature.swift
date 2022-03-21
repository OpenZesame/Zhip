//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import PINCode
import SwiftUI
import Wallet

public struct MainState: Equatable {
	
	public let wallet: Wallet
	public let pin: Pincode?
	
	public init(
		wallet: Wallet,
		maybePIN pin: Pincode?
	) {
		self.wallet = wallet
		self.pin = pin
	}
}

public enum MainAction: Equatable {
	
}

public struct MainEnvironment {
	public init() {}
}

public let mainReducer = Reducer<MainState, MainAction, MainEnvironment> { state, action, environment in
	return .none
}

public struct MainCoordinatorView: View {
	let store: Store<MainState, MainAction>
	public init(
		store: Store<MainState, MainAction>
	) {
		self.store = store
	}
	
	public var body: some View {
		Text("MainCoordinatorView unlock OR tabs")
	}
}
