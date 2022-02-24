//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI


// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
struct RestoreWalletUsingPrivateKeyScreen: View {
    @ObservedObject var viewModel: RestoreWalletUsingPrivateKeyViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 20) {
                InputField.privateKey(text: $viewModel.privateKey)
                PasswordInputFields(
                    password: $viewModel.password,
                    passwordConfirmation: $viewModel.passwordConfirmation
                )
                
                Button("Restore") {
                    Task {
                        await viewModel.restore()
                    }
                }
                .buttonStyle(.primary)
                .enabled(if: viewModel.canProceed)
                
            }.disableAutocorrection(true)
        }
    }
}

extension InputField {
    static func privateKey(
        prompt: String = "Private Key",
        text: Binding<String>
    ) -> Self {
        Self(
            prompt: prompt,
            text: text,
            isSecure: true,
            maxLength: 66, // "0x" + 64 hex private key chars => max length 66.
            characterRestriction: .onlyContains(whitelisted: .hexadecimalDigitsIncluding0x),
            validationRules: [
                ValidateInputRequirement.maximumLength(of: 64)
            ]
        )
    }
}
