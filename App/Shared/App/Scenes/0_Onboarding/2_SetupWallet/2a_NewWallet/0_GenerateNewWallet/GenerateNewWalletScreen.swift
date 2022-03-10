//
//  GenerateNewWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI
import Styleguide

// MARK: - GenerateNewWalletScreen
// MARK: -
struct GenerateNewWalletScreen: View {
    @ObservedObject var viewModel: GenerateNewWalletViewModel
}

// MARK: - View
// MARK: -
extension GenerateNewWalletScreen {
    
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 40) {
           
                Labels(
                    title: "Set an encryption password",
                    subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding."
                )
                
                PasswordInputFields(
                    password: $viewModel.password,
                    isPasswordValid: $viewModel.isPasswordValid,
                    passwordConfirmation: $viewModel.passwordConfirmation,
                    isPasswordConfirmationValid: $viewModel.isPasswordConfirmationValid
                )
                
                Spacer()
                
                Checkbox(
                    "I have securely backed up my encryption password",
                    isOn: $viewModel.userHasConfirmedBackingUpPassword
                )
                
                Button("Continue") {
                    Task { @MainActor in
                        await viewModel.continue()
                    }
                }
                .buttonStyle(.primary(isLoading: $viewModel.isGeneratingWallet))
                .enabled(if: viewModel.canProceed)
            }
            #if DEBUG
            .onAppear {
                    viewModel.password = unsafeDebugPassword
                    viewModel.passwordConfirmation = unsafeDebugPassword
                    viewModel.userHasConfirmedBackingUpPassword = true
            }
            #endif
        }
    }
}

#if DEBUG
let unsafeDebugPassword = "apabanan"
#endif

extension Array where Element == ValidateInputRequirement {
    static var encryptionPassword: [ValidateInputRequirement] {
       [
        ValidateInputRequirement.encryptionPassword
       ]
    }
}

extension ValidateInputRequirement {
    static let encryptionPassword: ValidateInputRequirement = { ValidateInputRequirement.minimumLength(of: 8) as! ValidateInputRequirement }()
}

struct PasswordInputFields: View {
    
    @Binding var password: String
    @Binding var isPasswordValid: Bool
    @Binding var passwordConfirmation: String
    @Binding var isPasswordConfirmationValid: Bool
    
    var body: some View {
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

extension InputField {
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
            validationRules: [ValidateInputRequirement.encryptionPassword] + additionalValidationRules
        )
    }
}
