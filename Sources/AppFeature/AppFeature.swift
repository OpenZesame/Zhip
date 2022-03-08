//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import OnboardingFeature
import UserDefaultsClient

public struct AppState: Equatable {
	public var onboarding: OnboardingState?
	
	public init(
		onboarding: OnboardingState = .init()
	) {
		self.onboarding = onboarding
	}
}

public enum AppAction: Equatable {
	case onboarding(OnboardingAction)
}

public struct AppEnvironment {
	public var userDefaults: UserDefaultsClient
	
	public init(
		userDefaults: UserDefaultsClient
	) {
		self.userDefaults = userDefaults
	}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	onboardingReducer
		.optional()
		.pullback(
			state: \.onboarding,
			action: /AppAction.onboarding,
			environment: {
				OnboardingEnvironment(
					userDefaults: $0.userDefaults
				)
			}
		),
	
	appReducerCore
)


let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
	switch action {
//	case let .onboarding(.delegate(action)):
//	  switch action {
//	  case .getStarted:
//		state.onboarding = nil
//		return .none
//	  }
//
	case .onboarding:
	  return .none
	}
}
