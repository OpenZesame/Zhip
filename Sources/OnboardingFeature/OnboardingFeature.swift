//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import UserDefaultsClient
import SwiftUI
import WelcomeFeature
import TermsOfServiceFeature

public struct OnboardingState: Equatable {
	public var step: Step
	public var welcome: WelcomeState
	public var termsOfService: TermsOfServiceState
	public init(
		step: Step = Step.allCases.first!,
		welcome: WelcomeState = .init(),
		termsOfService: TermsOfServiceState = .init()
	) {
		self.step = step
		self.welcome = welcome
		self.termsOfService = termsOfService
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
}

public struct OnboardingEnvironment {
	public var userDefaults: UserDefaultsClient
	
	public init(
		userDefaults: UserDefaultsClient
	) {
		self.userDefaults = userDefaults
	}
}

public let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
	
	termsOfServiceReducer.pullback(
		state: \.termsOfService,
		action: /OnboardingAction.termsOfServiceAction,
		environment: { TermsOfServiceEnvironment(userDefaults: $0.userDefaults) }
	),
	
	Reducer { state, action, environment in
		switch action {
		case .welcomeAction(.startButtonTapped):
			if environment.userDefaults.hasAcceptedTermsOfService {
				state = .init(step: .step2_SetupWallet)
			} else {
				state = .init(step: .step1_TermsOfService)
			}
			return .none
		case .termsOfServiceAction(.acceptButtonTapped):
			assert(environment.userDefaults.hasAcceptedTermsOfService)
			state = .init(step: .step2_SetupWallet)
		default: return .none
		}
		return .none
	}
)

public struct OnboardingView: View {
	let store: Store<OnboardingState, OnboardingAction>
	@ObservedObject var viewStore: ViewStore<ViewState, OnboardingAction>
	
	public init(store: Store<OnboardingState, OnboardingAction>) {
		self.store = store
		self.viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
	}
}

public extension OnboardingView {
	var body: some View {
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
			default:
				Text("TODO impl view for step: \(String(describing: viewStore.step))")
			}
		}
		
	}
}

public extension OnboardingView {
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
