//
//  GenerateNewWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI

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
                    passwordConfirmation: $viewModel.passwordConfirmation
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
                .disabled(!viewModel.isFinished)
            }
        }
    }
    
}

extension Array where Element == ValidateInputRequirement {
    static var encryptionPassword: [ValidateInputRequirement] {
        let rules: [ValidateInputRequirement] = [
            ValidateInputRequirement.minimumLength(of: 8) as! ValidateInputRequirement
        ]
        
        return rules
    }
}


struct PasswordInputFields: View {
    
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
    var body: some View {
        VStack(spacing: 20) {
            InputField(
                prompt: "Encryption password",
                text: $password,
                isSecure: true,
                validationRules: .encryptionPassword
            )
            
            InputField(
                prompt: "Confirm encryption password",
                text: $passwordConfirmation,
                isSecure: true,
                validationRules: [
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
