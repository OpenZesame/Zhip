//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-12.
//

import Foundation
import KeyValueStore

/// Abstraction of UserDefaults
public typealias Preferences = KeyValueStore<PreferencesKey>

public extension KeyValueStore where Key == PreferencesKey {
	static var `default`: Preferences {
		KeyValueStore(UserDefaults.standard)
	}
}

/// Insensitive values to be stored into e.g. `UserDefaults`, such as `hasAcceptedTermsOfService`
public enum PreferencesKey: String, KeyConvertible, Equatable, CaseIterable {
	case hasRunAppBefore
	case hasAcceptedTermsOfService
//    case hasAcceptedCustomECCWarning
//    case hasAnsweredCrashReportingQuestion
//    case hasAcceptedCrashReporting
	case skipPincodeSetup
	case balanceWasUpdatedAt
}


// MARK: - KeyValueStoring
extension UserDefaults: KeyValueStoring {}

public extension UserDefaults {

	func deleteValue(for key: String) throws {
		removeObject(forKey: key)
	}

	typealias Key = PreferencesKey

	func save(value: Any, for key: String) throws {
		if let bool = value as? Bool {
			self.set(bool, forKey: key)
		} else if let float = value as? Float {
			self.set(float, forKey: key)
		} else if let double = value as? Double {
			self.set(double, forKey: key)
		} else if let int = value as? Int {
			self.set(int, forKey: key)
		} else {
			self.setValue(value, forKey: key)
		}
	}

	func loadValue(for key: String) throws -> Any? {
		return value(forKey: key)
	}
}

