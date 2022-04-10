//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import Purger
import Screen
import Styleguide
import SwiftUI
import Wallet
import UserDefaultsClient

public enum Splash {}

public extension Splash {
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public init(
			alert: AlertState<Action>? = nil
		) {
			self.alert = alert
		}
	}
}

public extension Splash {
	enum Action: Equatable {
		case delegate(Delegate)
		case onAppear
		case checkForWallet
		case checkForWalletResult(Result<Wallet?, KeychainClient.Error>)
		case alertDismissed
		case walletIsFromPreviousInstallDeleteItAndSensitiveSettingsAndOnboardUser
		case setAppHasRunBefore(thenDelegate: Delegate)
	}
}
public extension Splash.Action {
	enum Delegate: Equatable {
		case foundWallet(Wallet)
		case noWallet
	}
}
public extension Splash {
	struct Environment {
		public let keychainClient: KeychainClient
		public let userDefaultsClient: UserDefaultsClient
		public let purger: Purger
		public init(
			keychainClient: KeychainClient,
			purger: Purger? = nil,
			userDefaultsClient: UserDefaultsClient
		) {
			self.keychainClient = keychainClient
			self.purger = purger ?? Purger(userDefaultsClient: userDefaultsClient, keychainClient: keychainClient)
			self.userDefaultsClient = userDefaultsClient
		}
	}
}

public extension Splash {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
		case .alertDismissed:
			state.alert = nil
			return Effect(value: .delegate(.noWallet))
			
		case .walletIsFromPreviousInstallDeleteItAndSensitiveSettingsAndOnboardUser:
			return Effect.merge(
				environment.purger.purge(
					.init(
						keepHasAppRunBeforeFlag: true,
						keepHasAcceptedTermsOfService: true
					)
				).fireAndForget(),
				Effect(value: Splash.Action.delegate(.noWallet))
			)
			
		case .onAppear:
			return Effect(value: .checkForWallet)
			
		case .checkForWallet:
			return environment
				.keychainClient
				.loadWallet()
				.catchToEffect(Splash.Action.checkForWalletResult)
			
		case let .checkForWalletResult(.failure(error)):
			state.alert = .init(title: .init("Failed to load wallet, underlying error: \(String(describing: error)). Please uninstall app an restore wallet from backup. Also please report this as a bug on github.com/openzesame/zhip/issues/new"))
			return .none
			
		case let .setAppHasRunBefore(delegateAction):
			return Effect(value: .delegate(delegateAction))
			
		case let .checkForWalletResult(.success(maybeWallet)):
			let delegateAction: Splash.Action.Delegate
			if let wallet = maybeWallet {
				guard
					environment.userDefaultsClient.hasRunAppBefore
				else {
					// Delete wallet upon reinstall if needed. This makes sure that after a reinstall of the app, the flag
					// `hasRunAppBefore`, which recides in UserDefaults - which gets reset after uninstalls, will be false
					// thus we should not have any wallet configured. Delete previous one if needed and onboard user.
					return Effect(value: .walletIsFromPreviousInstallDeleteItAndSensitiveSettingsAndOnboardUser)
				}
				delegateAction = .foundWallet(wallet)
				
			} else {
				delegateAction = .noWallet
			}
			
			return Effect.concatenate(
				environment.userDefaultsClient.setHasRunAppBefore(true).fireAndForget(),
				Effect(value: .setAppHasRunBefore(thenDelegate: delegateAction))
			)
			
		case .delegate(_):
			return .none
		}
	}
}

public extension Splash {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
		public var body: some View {
			WithViewStore(store) { viewStore in
				ZhipAuroraView()
					.onAppear { viewStore.send(.onAppear) }
					.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
			}
			
		}
	}
}
