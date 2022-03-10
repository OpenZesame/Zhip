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

public struct OnboardingState: Equatable {
	public var step: Step
	public var welcome: WelcomeState
	public init(
		step: Step = Step.allCases.first!,
		welcome: WelcomeState = .init()
	) {
		self.step = step
		self.welcome = welcome
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
}

public struct OnboardingEnvironment {
	public var userDefaults: UserDefaultsClient
	
	public init(
		userDefaults: UserDefaultsClient
	) {
		self.userDefaults = userDefaults
	}
}

public let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment> {
	state, action, environment in
	
	switch action {
	case .welcomeAction(.startButtonTapped):
		state = .init(step: .step1_TermsOfService)
		return .none
	default: return .none
	}
	return .none
}

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
