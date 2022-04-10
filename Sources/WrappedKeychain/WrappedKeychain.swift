import KeychainAccess
import Foundation
import PIN
import Wallet

public final class WrappedKeychain {
    private let wrapped: Keychain

	public init(
		service: String,
		label: String,
		accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly
	) {
        self.wrapped = Keychain(service: service)
            .label(label)
            .synchronizable(false)
            .accessibility(accessibility)
    }
}


public extension WrappedKeychain {
	
	func data(forKey key: String) throws -> Data? {
		try wrapped.getData(key)
	}
	
    /// Saves items in Keychain using access option `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
    /// Do not that means that if the user unsets the iOS passcode for their iOS device, then all data
    /// will be lost, read more:
    /// https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly
    func setData(_ data: Data, forKey key: String) throws {
		try wrapped.set(data, key: key)
    }

    func remove(forKey key: String) throws {
        try wrapped.remove(key)
    }
}
