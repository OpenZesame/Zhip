//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import UserDefaultsClient

public struct OnboardingState: Equatable {}
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
