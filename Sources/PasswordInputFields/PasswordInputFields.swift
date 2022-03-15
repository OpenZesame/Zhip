//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import Foundation
import InputField
import SwiftUI

public struct PasswordInputFields: View {
	
	@Binding public var password: String
	@Binding public var isPasswordValid: Bool
	@Binding public var passwordConfirmation: String
	@Binding public var isPasswordConfirmationValid: Bool

	public init(
		password: Binding<String>,
		isPasswordValid: Binding<Bool>,
		passwordConfirmation: Binding<String>,
		isPasswordConfirmationValid: Binding<Bool>
	) {
		self._password = password
		self._isPasswordValid = isPasswordValid
		self._passwordConfirmation = passwordConfirmation
		self._isPasswordConfirmationValid = isPasswordValid
	}

	public var body: some View {
		VStack(spacing: 20) {
 
			InputField.encryptionPassword(
				text: $password,
				isValid: $isPasswordValid
			)
			
			InputField.encryptionPassword(
				prompt: "Confirm encryption password",
				text: $passwordConfirmation,
				isValid: $isPasswordConfirmationValid,
				additionalValidationRules: [
					Validation { confirmText in
						if confirmText != password {
							return "Passwords does not match."
						}
						return nil // Valid
					}
				]
			)
		}
	}
}
