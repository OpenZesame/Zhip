//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-17.
//

#if DEBUG
import Foundation
import Zesame

public extension KDF {
	static let unsafeFast = Self.pbkdf2
}

public extension KDFParams {
	static var unsafeFast: Self {
		do {
			return try Self(
				costParameterN: 1,
				costParameterC: 1
			)
		} catch {
			fatalError("Incorrect implementation, should always be able to create default KDF params, unexpected error: \(error)")
		}
	}
}

#endif
