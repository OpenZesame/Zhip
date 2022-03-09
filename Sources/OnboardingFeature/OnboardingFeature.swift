//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import UserDefaultsClient
import SwiftUI

public struct OnboardingState: Equatable {
	public var step: Step
	public init(
		step: Step = Step.allCases.first!
	) {
		self.step = step
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

public enum OnboardingAction: Equatable {}

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
	
//	switch action {
//
//	}
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
		Text("Onboarding view")
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
