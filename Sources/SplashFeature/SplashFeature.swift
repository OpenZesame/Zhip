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

public struct SplashState: Equatable {
	public var alert: AlertState<SplashAction>?
	public init(
		alert: AlertState<SplashAction>? = nil
	) {
		self.alert = alert
	}
}
public enum SplashAction: Equatable {
	case delegate(DelegateAction)
	case onAppear
	case checkForWallet
	case checkForWalletResult(Result<Wallet?, KeychainClient.Error>)
	case alertDismissed
	case walletIsFromPreviousInstallDeleteItAndSensitiveSettingsAndOnboardUser
	case setAppHasRunBefore(thenDelegate: DelegateAction)
}
public extension SplashAction {
	enum DelegateAction: Equatable {
		case foundWallet(Wallet)
		case noWallet
	}
}
public struct SplashEnvironment {
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

public let splashReducer = Reducer<SplashState, SplashAction, SplashEnvironment> { state, action, environment in
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
			Effect(value: SplashAction.delegate(.noWallet))
		)
		
	case .onAppear:
		return Effect(value: .checkForWallet)
		
	case .checkForWallet:
		return environment
			.keychainClient
			.loadWallet()
			.catchToEffect(SplashAction.checkForWalletResult)
	
	case let .checkForWalletResult(.failure(error)):
		state.alert = .init(title: .init("Failed to load wallet, underlying error: \(String(describing: error)). Please uninstall app an restore wallet from backup. Also please report this as a bug on github.com/openzesame/zhip/issues/new"))
		return .none
	
	case let .setAppHasRunBefore(delegateAction):
		return Effect(value: .delegate(delegateAction))
	
	case let .checkForWalletResult(.success(maybeWallet)):
		let delegateAction: SplashAction.DelegateAction
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

public struct SplashView: View {
	let store: Store<SplashState, SplashAction>
	public init(store: Store<SplashState, SplashAction>) {
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
