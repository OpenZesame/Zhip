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
	
	var hasRunAppBefore: Bool {
		boolForKey(hasRunAppBeforeKey)
	}

	func setHasRunAppBefore(_ bool: Bool) -> Effect<Never, Never> {
		setBool(bool, hasRunAppBeforeKey)
	}
	
	var hasAcceptedTermsOfService: Bool {
		boolForKey(hasAcceptedTermsOfServiceKey)
	}

	func setHasAcceptedTermsOfService(_ bool: Bool) -> Effect<Never, Never> {
		setBool(bool, hasAcceptedTermsOfServiceKey)
	}
	
	func removeAll(
		butKeepHasAppRunBeforeFlag keepHasAppRunBeforeFlag: Bool = true,
		butKeepHasAcceptedTermsOfService keepHasAcceptedTermsOfService: Bool = true
	) -> Effect<Never, Never> {
		let maybeRemoveHasAppRunBefore: Effect<Never, Never> = keepHasAppRunBeforeFlag ? Effect.fireAndForget {} : remove(hasRunAppBeforeKey)
		let maybeRemoveHasAcceptedToS: Effect<Never, Never> = keepHasAcceptedTermsOfService ? Effect.fireAndForget {} : remove(hasAcceptedTermsOfServiceKey)

		return Effect.concatenate(
			maybeRemoveHasAppRunBefore,
			maybeRemoveHasAcceptedToS
		)
	}
}

private let hasRunAppBeforeKey = "hasRunAppBeforeKey"
private let hasAcceptedTermsOfServiceKey = "hasAcceptedTermsOfServiceKey"
