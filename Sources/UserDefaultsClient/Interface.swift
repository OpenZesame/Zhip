import ComposableArchitecture
import Foundation

public struct UserDefaultsClient {
	public var boolForKey: (String) -> Bool
	public var dataForKey: (String) -> Data?
	public var doubleForKey: (String) -> Double
	public var integerForKey: (String) -> Int
	public var remove: (String) -> Effect<Never, Never>
	public var setBool: (Bool, String) -> Effect<Never, Never>
	public var setData: (Data?, String) -> Effect<Never, Never>
	public var setDouble: (Double, String) -> Effect<Never, Never>
	public var setInteger: (Int, String) -> Effect<Never, Never>
}

public extension UserDefaultsClient {
	
	var hasShownFirstLaunchOnboarding: Bool {
		boolForKey(hasShownFirstLaunchOnboardingKey)
	}

	func setHasShownFirstLaunchOnboarding(_ bool: Bool) -> Effect<Never, Never> {
		setBool(bool, hasShownFirstLaunchOnboardingKey)
	}
	
	var hasAcceptedTermsOfService: Bool {
		boolForKey(hasAcceptedTermsOfServiceKey)
	}

	func setHasAcceptedTermsOfService(_ bool: Bool) -> Effect<Never, Never> {
		setBool(bool, hasAcceptedTermsOfServiceKey)
	}
}

private let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
private let hasAcceptedTermsOfServiceKey = "hasAcceptedTermsOfServiceKey"
