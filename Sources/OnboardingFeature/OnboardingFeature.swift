//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import KeychainClient
import NewPINFeature
import PasswordValidator
import PINCode
import SetupWalletFeature
import SwiftUI
import TermsOfServiceFeature
import UserDefaultsClient
import WelcomeFeature
import Wallet
import WalletGenerator
import WalletRestorer

// MARK: - Onboarding
// MARK: -

/// Onboarding flow, guides the user from app (re-)installation to being ready
/// to use the app.
public enum Onboarding {}

// MARK: - Step
// MARK: -
public extension Onboarding {
	/// Components of the onboarding flow, can either be a single screen or
	/// a subflow consisting of multiple screens, or subsubflows.
	enum Step: Equatable {
		case step0_Welcome
		case step1_TermsOfService
		case step2_SetupWallet
		case step3_NewPIN
	}
}

// MARK: - State
// MARK: -
public extension Onboarding {
	struct State: Equatable {
		public var step: Step
		
		public var welcome: WelcomeState?
		public var termsOfService: TermsOfServiceState?
		public var setupWallet: SetupWalletState?
		public var newPIN: NewPINState?
		
		public init(
			step: Step = .step0_Welcome,
			welcome: WelcomeState? = nil,
			termsOfService: TermsOfServiceState? = nil,
			setupWallet: SetupWalletState? = nil,
			newPIN: NewPINState? = nil
		) {
			self.step = step
			self.welcome = .init()
			self.termsOfService = termsOfService
			self.setupWallet = setupWallet
			self.newPIN = newPIN
		}
	}
}

// MARK: - Action
// MARK: -
public extension Onboarding {
	enum Action: Equatable {
		case delegate(Delegate)
		
		case welcome(WelcomeAction)
		case termsOfService(TermsOfServiceAction)
		case setupWallet(SetupWalletAction)
		case newPIN(NewPINAction)
	}
}

public extension Onboarding.Action {
	enum Delegate: Equatable {
		case finished(wallet: Wallet, pin: Pincode?)
	}
}

// MARK: - Environment
// MARK: -
public extension Onboarding {
	
	struct Environment {
		
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public var keychainClient: KeychainClient
		public var mainQueue: AnySchedulerOf<DispatchQueue>
		public var passwordValidator: PasswordValidator
		public var userDefaults: UserDefaultsClient
		public var walletGenerator: WalletGenerator
		public var walletRestorer: WalletRestorer
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			keychainClient: KeychainClient,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			userDefaults: UserDefaultsClient,
			walletGenerator: WalletGenerator,
			walletRestorer: WalletRestorer
		) {
			self.backgroundQueue = backgroundQueue
			self.keychainClient = keychainClient
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.userDefaults = userDefaults
			self.walletGenerator = walletGenerator
			self.walletRestorer = walletRestorer
		}
	}
}

// MARK: - Reducer
// MARK: -
public extension Onboarding {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		welcomeReducer
			.optional()
			.pullback(
				state: \.welcome,
				action: /Action.welcome,
				environment: { _ in
					WelcomeEnvironment()
				}
			),
		
		termsOfServiceReducer
			.optional()
			.pullback(
				state: \.termsOfService,
				action: /Action.termsOfService,
				environment: { TermsOfServiceEnvironment(userDefaults: $0.userDefaults) }
			),
		
		setupWalletReducer
			.optional()
			.pullback(
				state: \.setupWallet,
				action: /Action.setupWallet,
				environment: {
					SetupWalletEnvironment(
						backgroundQueue: $0.backgroundQueue,
						keychainClient: $0.keychainClient,
						mainQueue: $0.mainQueue,
						passwordValidator: $0.passwordValidator,
						walletGenerator: $0.walletGenerator,
						walletRestorer: $0.walletRestorer
					)
				}
			),
		
		newPINReducer
			.optional()
			.pullback(
				state: \.newPIN,
				action: /Action.newPIN,
				environment: {
					NewPINEnvironment(
						keychainClient: $0.keychainClient,
						mainQueue: $0.mainQueue
					)
				}
			),
		
		Reducer { state, action, environment in
			switch action {
			case .welcome(.delegate(.getStarted)):
				if environment.userDefaults.hasAcceptedTermsOfService {
					state = .init(
						step: .step2_SetupWallet,
						setupWallet: .init()
					)
				} else {
					state = .init(
						step: .step1_TermsOfService,
						termsOfService: .init(mode: .mandatoryToAcceptTermsAsPartOfOnboarding)
					)
				}
				return .none
			case .welcome(_):
				return .none
				
			case .termsOfService(.delegate(.didAcceptTermsOfService)):
				assert(environment.userDefaults.hasAcceptedTermsOfService)
				state.setupWallet = .init()
				state.step = .step2_SetupWallet
				return .none
				
			case .termsOfService(.delegate(.done)):
				assertionFailure("Done button should not be able to press when TermsOfService is presented from Onboarding.")
				state.setupWallet = .init()
				state.step = .step2_SetupWallet
				return .none
				
			case let .setupWallet(.delegate(.finishedSettingUpWallet(wallet))):
				state.newPIN = .init(wallet: wallet)
				state.step = .step3_NewPIN
				return .none
				
			case let .newPIN(.delegate(.skippedPIN(wallet))):
				return Effect(value: .delegate(.finished(wallet: wallet, pin: nil)))
			case let .newPIN(.delegate(.finishedSettingUpPIN(wallet, pin))):
				return Effect(value: .delegate(.finished(wallet: wallet, pin: pin)))
				
			default:
				return .none
			}
		}
	)
}

// MARK: - Screen
// MARK: -
public extension Onboarding {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

public extension Onboarding.CoordinatorScreen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			NavigationView {
				Group {
					switch viewStore.step {
					case .step0_Welcome:
						IfLetStore(
							store.scope(
								state: \.welcome,
								action: Onboarding.Action.welcome
							),
							then: WelcomeScreen.init(store:)
						)
					case .step1_TermsOfService:
						IfLetStore(
							store.scope(
								state: \.termsOfService,
								action: Onboarding.Action.termsOfService
							),
							then: TermsOfServiceScreen.init(store:)
						)
					case .step2_SetupWallet:
						IfLetStore(
							store.scope(
								state: \.setupWallet,
								action: Onboarding.Action.setupWallet
							),
							then: SetupWalletCoordinatorView.init(store:)
						)
					case .step3_NewPIN:
						IfLetStore(
							store.scope(
								state: \.newPIN,
								action: Onboarding.Action.newPIN
							),
							then: NewPINCoordinatorView.init(store:)
						)
					}
				}
			}
		}
	}
}

// MARK: - ViewState
// MARK: - 
private extension Onboarding.CoordinatorScreen {
	struct ViewState: Equatable {
		let isSkipButtonVisible: Bool
		let step: Onboarding.Step
		
		init(state: Onboarding.State) {
			let step = state.step
			switch step {
			case .step3_NewPIN:
				self.isSkipButtonVisible = true
			default:
				self.isSkipButtonVisible = false
			}
			self.step = step
		}
	}
}
