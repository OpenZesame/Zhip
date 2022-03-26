//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import Foundation
import HoverPromptTextField
import PasswordValidator
import SwiftUI


public extension ValidateInputRequirement {
	static let encryptionPassword: ValidateInputRequirement = { ValidateInputRequirement.minimumLength(of: minimumEncryptionPasswordLength) as! ValidateInputRequirement }()
}

public extension InputField {
	static func encryptionPassword(
		prompt: String = "Encryption password",
		text: Binding<String>,
		isValid: Binding<Bool>? = nil,
		additionalValidationRules: [Validation] = []
	) -> Self {
		Self(
			prompt: prompt,
			text: text,
			isValid: isValid,
			isSecure: true,
			minLength: minimumEncryptionPasswordLength,
			validationRules: [ValidateInputRequirement.encryptionPassword] + additionalValidationRules
		)
	}
}

public extension Array where Element == ValidateInputRequirement {
	static var encryptionPassword: [ValidateInputRequirement] {
	   [
		ValidateInputRequirement.encryptionPassword
	   ]
	}
}
