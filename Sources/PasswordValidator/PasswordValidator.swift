//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-26.
//

import Foundation

/// TODO replace with Zesame.minLengthOfPassword
public let minimumEncryptionPasswordLength = 8

public struct ValidatePasswordsRequest: Equatable {
	public let password: String
	public let confirmPassword: String

	public init(
		password: String,
		confirmPassword: String
	) {
		self.password = password
		self.confirmPassword = confirmPassword
	}
}

public struct PasswordValidator {
	
	public typealias ValidatePasswords = (ValidatePasswordsRequest) -> Bool
	
	public var validatePasswords: ValidatePasswords
	
	public init(validatePasswords: @escaping ValidatePasswords) {
		self.validatePasswords = validatePasswords
	}
}

public extension PasswordValidator {
	static let live = Self(
		validatePasswords: { request in
			_validatePasswords(
				request.password,
				confirmedBy: request.confirmPassword
			)
		}
	)
}

private func _validate(password: String) -> Bool {
	guard
		password.count >= minimumEncryptionPasswordLength
	else {
		return false
	}
	return true
}

private func _validatePasswords(
	_ password: String,
	confirmedBy passwordConfirmation: String
) -> Bool {
	guard [password, passwordConfirmation].allSatisfy(_validate) else {
		return false
	}
	
	return password == passwordConfirmation
}
