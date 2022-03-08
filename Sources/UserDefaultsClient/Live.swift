import Foundation

public extension UserDefaultsClient {
	static func live(
		userDefaults: UserDefaults = UserDefaults(suiteName: "group.zhip")!
	) -> Self {
		Self(
			boolForKey: userDefaults.bool(forKey:),
			dataForKey: userDefaults.data(forKey:),
			doubleForKey: userDefaults.double(forKey:),
			integerForKey: userDefaults.integer(forKey:),
			remove: { key in
					.fireAndForget {
						userDefaults.removeObject(forKey: key)
					}
			},
			setBool: { value, key in
					.fireAndForget {
						userDefaults.set(value, forKey: key)
					}
			},
			setData: { data, key in
					.fireAndForget {
						userDefaults.set(data, forKey: key)
					}
			},
			setDouble: { value, key in
					.fireAndForget {
						userDefaults.set(value, forKey: key)
					}
			},
			setInteger: { value, key in
					.fireAndForget {
						userDefaults.set(value, forKey: key)
					}
			}
		)
	}
}

