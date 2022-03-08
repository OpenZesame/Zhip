//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import UserDefaultsClient

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
		case step1_Welcome
		case step2_TermsOfService
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
