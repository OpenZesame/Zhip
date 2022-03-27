//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import EnsurePrivacyFeature
import PasswordValidator
import SwiftUI
import Wallet
import enum Zesame.KDF
import struct Zesame.KDFParams

public enum RestoreWalletState: Equatable {
	
	case step1_EnsurePrivacy(EnsurePrivacyState)
	case step2_RestoreWallet(RestoreWalletMethodState)
	
	public init() {
		self = .step1_EnsurePrivacy(EnsurePrivacyState.init())
	}
}


public enum RestoreWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case ensurePrivacy(EnsurePrivacyAction)
	case restoreUsingMethod(RestoreWalletMethodAction)
	
}
public extension RestoreWalletAction {
	enum DelegateAction: Equatable {
		case finishedRestoringWallet(Wallet)
		case abortMightBeWatched
	}
}

public struct RestoreWalletEnvironment {
	public var kdf: KDF
	public var kdfParams: KDFParams
	public let passwordValidator: PasswordValidator
	public init(
		kdf: KDF,
		kdfParams: KDFParams,
		passwordValidator: PasswordValidator
	) {
		self.kdf = kdf
		self.kdfParams = kdfParams
		self.passwordValidator = passwordValidator
	}
}

public let restoreWalletReducer = Reducer<RestoreWalletState, RestoreWalletAction, RestoreWalletEnvironment>.combine(

	ensurePrivacyReducer.pullback(
		state: /RestoreWalletState.step1_EnsurePrivacy,
		action: /RestoreWalletAction.ensurePrivacy,
		environment: { _ in
			EnsurePrivacyEnvironment()
		}
	),
	
	restoreWalletMethodReducer.pullback(
		state: /RestoreWalletState.step2_RestoreWallet,
		action: /RestoreWalletAction.restoreUsingMethod,
		environment: {
			RestoreWalletMethodEnvironment(
				kdf: $0.kdf,
				kdfParams: $0.kdfParams,
				passwordValidator: $0.passwordValidator
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
		case .ensurePrivacy(.delegate(.abort)):
			return Effect(value: .delegate(.abortMightBeWatched))
		case .ensurePrivacy(.delegate(.proceed)):
			state = .step2_RestoreWallet(.init())
			return .none
		case .ensurePrivacy(_):
			return .none
		case let .restoreUsingMethod(.delegate(.finishedRestoring(wallet))):
			return Effect(value: .delegate(.finishedRestoringWallet(wallet)))
		case .restoreUsingMethod(_):
			return .none
		case .delegate(_):
			return .none
		}
	}
)

public struct RestoreWalletCoordinatorView: View {
	let store: Store<RestoreWalletState, RestoreWalletAction>
	public init(
		store: Store<RestoreWalletState, RestoreWalletAction>
	) {
		self.store = store
	}
}

public extension RestoreWalletCoordinatorView {
	var body: some View {
		SwitchStore(store) {
			CaseLet(
				state: /RestoreWalletState.step1_EnsurePrivacy,
				action: RestoreWalletAction.ensurePrivacy,
				then: EnsurePrivacyScreen.init(store:)
			)
			
			CaseLet(
				state: /RestoreWalletState.step2_RestoreWallet,
				action: RestoreWalletAction.restoreUsingMethod,
				then: RestoreWalletScreen.init(store:)
			)
			
			
		}
	}
}
