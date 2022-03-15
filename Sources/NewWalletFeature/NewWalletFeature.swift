//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import BackUpWalletFeature
import ComposableArchitecture
import EnsurePrivacyFeature
import GenerateNewWalletFeature
import SwiftUI
import WalletGenerator

public struct NewWalletState: Equatable {
	
	public enum Step: Equatable {
		case step1_EnsurePrivacy
		case step2_GenerateNewWallet
		case step3_BackUpWallet
	}
	
	public var step: Step
	public var ensurePrivacy: EnsurePrivacyState
	public var generateNewWallet: GenerateNewWalletState
	public var backUpWallet: BackUpWalletState
	
	public init(
		step: Step = .step1_EnsurePrivacy,
		ensurePrivacy: EnsurePrivacyState = .init(),
		generateNewWallet: GenerateNewWalletState = .init(),
		backUpWallet: BackUpWalletState = .init()
	) {
		self.step = step
		self.ensurePrivacy = ensurePrivacy
		self.generateNewWallet = generateNewWallet
		self.backUpWallet = backUpWallet
	}
}

public enum NewWalletAction: Equatable {
	case delegate(DelegateAction)
	
	case ensurePrivacy(EnsurePrivacyAction)
	case generateNewWallet(GenerateNewWalletAction)
	case backUpWallet(BackUpWalletAction)
}
public extension NewWalletAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpNewWallet
		case abortMightBeWatched
	}
}

public struct NewWalletEnvironment {
	public let walletGenerator: WalletGenerator
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		walletGenerator: WalletGenerator,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.walletGenerator = walletGenerator
		self.mainQueue = mainQueue
	}
}

public let newWalletReducer = Reducer<NewWalletState, NewWalletAction, NewWalletEnvironment>.combine(
	
	ensurePrivacyReducer.pullback(
		state: \.ensurePrivacy,
		action: /NewWalletAction.ensurePrivacy,
		environment: { _ in EnsurePrivacyEnvironment() }
	),
	
	generateNewWalletReducer.pullback(
		state: \.generateNewWallet,
		action: /NewWalletAction.generateNewWallet,
		environment: {
			GenerateNewWalletEnvironment(
				walletGenerator: $0.walletGenerator,
				mainQueue: $0.mainQueue
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
		case .ensurePrivacy(.delegate(.abort)):
			return Effect(value: .delegate(.abortMightBeWatched))
		case .ensurePrivacy(.delegate(.proceed)):
			state.step = .step2_GenerateNewWallet
			return .none
		case .generateNewWallet(.delegate(.finishedGeneratingNewWallet)):
			state.step = .step3_BackUpWallet
			return .none
		default: return .none
		}
	}
)

public struct NewWalletCoordinatorView: View {
	let store: Store<NewWalletState, NewWalletAction>
	public init(
		store: Store<NewWalletState, NewWalletAction>
	) {
		self.store = store
	}
}

public extension NewWalletCoordinatorView {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Group {
				switch viewStore.step {
				case .step1_EnsurePrivacy:
					EnsurePrivacyScreen(
						store: store.scope(
							state: \.ensurePrivacy,
							action: NewWalletAction.ensurePrivacy
						)
					)
				case .step2_GenerateNewWallet:
					GenerateNewWalletScreen(
						store: store.scope(
							state: \.generateNewWallet,
							action: NewWalletAction.generateNewWallet
						)
					)
				case .step3_BackUpWallet:
					BackUpWalletCoordinatorView(
						store: store.scope(
							state: \.backUpWallet,
							action: NewWalletAction.backUpWallet
						)
					)
					
				}
			}
		}
	}
}

private extension NewWalletCoordinatorView {
	struct ViewState: Equatable {
		let step: NewWalletState.Step
		init(state: NewWalletState) {
			self.step = state.step
		}
	}
}
