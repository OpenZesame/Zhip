//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import SwiftUI
import Screen
import Styleguide
import UserDefaultsClient
import Wallet

public struct SettingsState: Equatable {
	public init() {}
}
public enum SettingsAction: Equatable {
	case delegate(DelegateAction)
}
public extension SettingsAction {
	enum DelegateAction: Equatable {
		case userDeletedWallet
	}
}
public struct SettingsEnvironment {
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

public let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
	return .none
}

public struct SettingsView: View {
	let store: Store<SettingsState, SettingsAction>
	public init(
		store: Store<SettingsState, SettingsAction>
	) {
		self.store = store
	}
}

public extension SettingsView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Settings")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Settings")
		}
	}
}
