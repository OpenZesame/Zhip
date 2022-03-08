
public extension UserDefaultsClient {
	static let noop = Self(
		boolForKey: { _ in false },
		dataForKey: { _ in nil },
		doubleForKey: { _ in 0 },
		integerForKey: { _ in 0 },
		remove: { _ in .none },
		setBool: { _, _ in .none },
		setData: { _, _ in .none },
		setDouble: { _, _ in .none },
		setInteger: { _, _ in .none }
	)
}

#if DEBUG
import Foundation
import XCTestDynamicOverlay

public extension UserDefaultsClient {
	 static let failing = Self(
		boolForKey: {
			key
			in XCTFail("\(Self.self).boolForKey(\(key)) is unimplemented")
			return false
		},
		dataForKey: { key in
			XCTFail("\(Self.self).dataForKey(\(key)) is unimplemented")
			return nil
		},
		doubleForKey: { key in
			XCTFail("\(Self.self).doubleForKey(\(key)) is unimplemented")
			return 0
		},
		integerForKey: { key in
			XCTFail("\(Self.self).integerForKey(\(key)) is unimplemented")
			return 0
		},
		remove: { key in .failing("\(Self.self).remove(\(key)) is unimplemented") },
		setBool: { _, key in .failing("\(Self.self).setBool(\(key), _) is unimplemented") },
		setData: { _, key in .failing("\(Self.self).setData(\(key), _) is unimplemented") },
		setDouble: { _, key in .failing("\(Self.self).setDouble(\(key), _) is unimplemented") },
		setInteger: { _, key in .failing("\(Self.self).setInteger(\(key), _) is unimplemented") }
	)
	
	mutating func override(bool: Bool, forKey key: String) {
		boolForKey = { [self] in $0 == key ? bool : self.boolForKey(key) }
	}
	
	mutating func override(data: Data, forKey key: String) {
		dataForKey = { [self] in $0 == key ? data : self.dataForKey(key) }
	}
	
	mutating func override(double: Double, forKey key: String) {
		doubleForKey = { [self] in $0 == key ? double : self.doubleForKey(key) }
	}
	
	mutating func override(integer: Int, forKey key: String) {
		integerForKey = { [self] in $0 == key ? integer : self.integerForKey(key) }
	}
}
#endif
