//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-15.
//

import Foundation
import WalletGenerator

//#if DEBUG
//		self.kdf = .pbkdf2
//		self.kdfParams = KDFParams.unsafeFast
//#else
//		self.kdf = kdf ?? .default
//		self.kdfParams = kdfParams ?? KDFParams.default
//#endif

#if DEBUG
public extension WalletGenerator {
	static let unsafeFast: Self = {
		
		let unsafeWalletGenerator = Self(
			generate: { _ in fatalError() }
		)
		
		let warningString = "☣️"
		let separator = String(repeating: warningString, count: 20)
		print("\n")
		print(separator)
		print("\(warningString) Warning using unsafe wallet generator \(warningString)")
		print(separator)
		print("\n")
		
		return unsafeWalletGenerator
	}()
}
#else
private enum Inhabited {}
#endif
