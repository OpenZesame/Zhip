//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import SetupWalletFeature
import SwiftUI
import TermsOfServiceFeature
import UserDefaultsClient
import WelcomeFeature
import WalletGenerator

public struct OnboardingState: Equatable {
	public var step: Step
	public var welcome: WelcomeState
	public var termsOfService: TermsOfServiceState
	public var setupWallet: SetupWalletState
	public init(
		step: Step = Step.allCases.first!,
		welcome: WelcomeState = .init(),
		termsOfService: TermsOfServiceState = .init(),
		setupWallet: SetupWalletState = .init()
	) {
		self.step = step
		self.welcome = welcome
		self.termsOfService = termsOfService
		self.setupWallet = setupWallet
	}
}

public extension OnboardingState {
	enum Step: Int, CaseIterable, Comparable, Equatable {
		case step0_Welcome
		case step1_TermsOfService
		case step2_SetupWallet
		case step3_NewPIN
	}
}

public extension OnboardingState.Step {
	static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

public enum OnboardingAction: Equatable {
	case welcomeAction(WelcomeAction)
	case termsOfServiceAction(TermsOfServiceAction)
	case setupWalletAction(SetupWalletAction)
}

public struct OnboardingEnvironment {
	public var userDefaults: UserDefaultsClient
	public var walletGenerator: WalletGenerator
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		userDefaults: UserDefaultsClient,
		walletGenerator: WalletGenerator,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.userDefaults = userDefaults
		self.walletGenerator = walletGenerator
		self.mainQueue = mainQueue
	}
}

public let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
	
	termsOfServiceReducer.pullback(
		state: \.termsOfService,
		action: /OnboardingAction.termsOfServiceAction,
		environment: { TermsOfServiceEnvironment(userDefaults: $0.userDefaults) }
	),
	
	setupWalletReducer.pullback(
		state: \.setupWallet,
		action: /OnboardingAction.setupWalletAction,
		environment: {
			SetupWalletEnvironment(
				walletGenerator: $0.walletGenerator,
				mainQueue: $0.mainQueue
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
		case .welcomeAction(.delegate(.getStarted)):
			if environment.userDefaults.hasAcceptedTermsOfService {
				state = .init(step: .step2_SetupWallet)
			} else {
				state = .init(step: .step1_TermsOfService)
			}
			return .none
		case .termsOfServiceAction(.delegate(.didAcceptTermsOfService)):
			assert(environment.userDefaults.hasAcceptedTermsOfService)
			state = .init(step: .step2_SetupWallet)
			return .none
			
		case .setupWalletAction(.delegate(.finishedSettingUpWallet)):
			fatalError()
			
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
					WelcomeScreen(
						store: store.scope(
							state: \.welcome,
							action: OnboardingAction.welcomeAction
						)
					)
				case .step1_TermsOfService:
					TermsOfServiceScreen(
						store: store.scope(
							state: \.termsOfService,
							action: OnboardingAction.termsOfServiceAction
						)
					)
				case .step2_SetupWallet:
					SetupWalletCoordinatorView(
						store: store.scope(
							state: \.setupWallet,
							action: OnboardingAction.setupWalletAction
						)
					)
				default:
					Text("TODO impl view for step: \(String(describing: viewStore.step))")
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
			self.isSkipButtonVisible = step == .step3_NewPIN
			self.step = step
		}
	}
}
