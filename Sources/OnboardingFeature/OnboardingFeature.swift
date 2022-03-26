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


public struct OnboardingState: Equatable {
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

public extension OnboardingState {
	enum Step: Equatable {
		case step0_Welcome
		case step1_TermsOfService
		case step2_SetupWallet
		case step3_NewPIN(wallet: Wallet)
	}
}


public enum OnboardingAction: Equatable {
	case delegate(DelegateAction)
	
	case welcome(WelcomeAction)
	case termsOfService(TermsOfServiceAction)
	case setupWallet(SetupWalletAction)
	case newPIN(NewPINAction)
}
public extension OnboardingAction {
	enum DelegateAction: Equatable {
		case finishedOnboarding(wallet: Wallet, pin: Pincode?)
	}
}

public struct OnboardingEnvironment {
	public var keychainClient: KeychainClient
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	public var passwordValidator: PasswordValidator
	public var userDefaults: UserDefaultsClient
	public var walletGenerator: WalletGenerator
	
	public init(
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>,
		passwordValidator: PasswordValidator,
		userDefaults: UserDefaultsClient,
		walletGenerator: WalletGenerator
	) {
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
		self.passwordValidator = passwordValidator
		self.userDefaults = userDefaults
		self.walletGenerator = walletGenerator
	}
}

public let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
	
	termsOfServiceReducer
		.optional()
		.pullback(
		state: \.termsOfService,
		action: /OnboardingAction.termsOfService,
		environment: { TermsOfServiceEnvironment(userDefaults: $0.userDefaults) }
	),
	
	setupWalletReducer
		.optional()
		.pullback(
		state: \.setupWallet,
		action: /OnboardingAction.setupWallet,
		environment: {
			SetupWalletEnvironment(
				keychainClient: $0.keychainClient,
				mainQueue: $0.mainQueue,
				passwordValidator: $0.passwordValidator,
				walletGenerator: $0.walletGenerator
			)
		}
	),
	
	newPINReducer
		.optional()
		.pullback(
		state: \.newPIN,
		action: /OnboardingAction.newPIN,
		environment: {
			NewPINEnvironment(
				keychainClient: $0.keychainClient
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
			state.step = .step3_NewPIN(wallet: wallet)
			return .none
			
		case let .newPIN(.delegate(.skippedPIN(wallet))):
			return Effect(value: .delegate(.finishedOnboarding(wallet: wallet, pin: nil)))
		case let .newPIN(.delegate(.finishedSettingUpPIN(wallet, pin))):
			return Effect(value: .delegate(.finishedOnboarding(wallet: wallet, pin: pin)))
			
		default:
			return .none
		}
	}
)

public struct OnboardingCoordinatorView: View {
	let store: Store<OnboardingState, OnboardingAction>
	
	public init(store: Store<OnboardingState, OnboardingAction>) {
		self.store = store
	}
}

public extension OnboardingCoordinatorView {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Group {
				switch viewStore.step {
				case .step0_Welcome:
					IfLetStore(
						store.scope(
							state: \.welcome,
							action: OnboardingAction.welcome
						),
						then: WelcomeScreen.init(store:)
					)
				case .step1_TermsOfService:
					IfLetStore(
						store.scope(
							state: \.termsOfService,
							action: OnboardingAction.termsOfService
						),
						then: TermsOfServiceScreen.init(store:)
					)
				case .step2_SetupWallet:
					IfLetStore(
						store.scope(
							state: \.setupWallet,
							action: OnboardingAction.setupWallet
						),
						then: SetupWalletCoordinatorView.init(store:)
					)
				case .step3_NewPIN:
					IfLetStore(
						store.scope(
							state: \.newPIN,
							action: OnboardingAction.newPIN
						),
						then: NewPINCoordinatorView.init(store:)
					)
				}
			}
		}
	}
}

private extension OnboardingCoordinatorView {
	struct ViewState: Equatable {
		let isSkipButtonVisible: Bool
		let step: OnboardingState.Step
		
		init(state: OnboardingState) {
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
