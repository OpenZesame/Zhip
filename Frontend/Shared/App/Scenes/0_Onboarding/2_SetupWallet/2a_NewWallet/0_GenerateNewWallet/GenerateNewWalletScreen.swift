//
//  GenerateNewWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI

struct GenerateNewWalletScreen<ViewModel: GenerateNewWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
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
                
                passwordInputFields
                
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

private extension GenerateNewWalletScreen {
    var passwordInputFields: some View {
        VStack(spacing: 20) {
            InputField(
                prompt: "Encryption password",
                text: $viewModel.password,
                isSecure: true,
                validationRules: [.minimumLength(of: 8)]
            )
            
            InputField(
                prompt: "Confirm encryption password",
                text: $viewModel.passwordConfirmation,
                isSecure: true,
                validationRules: [
                    Validation { confirmText in
                        if confirmText != viewModel.password {
                            return "Passwords does not match."
                        }
                        return nil // Valid
                    }
                ]
            )
        }
    }
}
