//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-20.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import Screen
import Styleguide
import SwiftUI
import Wallet

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
}
public extension SplashAction {
	enum DelegateAction: Equatable {
		case foundWallet(Wallet)
		case noWallet
	}
}
public struct SplashEnvironment {
	public let keychainClient: KeychainClient
	public init(
		keychainClient: KeychainClient
	) {
		self.keychainClient = keychainClient
	}
}

public let splashReducer = Reducer<SplashState, SplashAction, SplashEnvironment> { state, action, environment in
	switch action {
	case .alertDismissed:
		state.alert = nil
		return Effect(value: .delegate(.noWallet))
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
	case let .checkForWalletResult(.success(maybeWallet)):
		if let wallet = maybeWallet {
			return Effect(value: .delegate(.foundWallet(wallet)))
		} else {
			return Effect(value: .delegate(.noWallet))
		}
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
