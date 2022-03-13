//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Styleguide
import struct Zesame.PrivateKey
import InputField
import Screen


// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
struct RestoreWalletUsingPrivateKeyScreen: View {
//    @ObservedObject var viewModel: RestoreWalletUsingPrivateKeyViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
		Text("Code commented out")
//        ForceFullScreen {
//            VStack(spacing: 20) {
//                InputField.privateKey(text: $viewModel.privateKeyHex, isValid: $viewModel.isPrivateKeyValid)
//
//                PasswordInputFields(
//                    password: $viewModel.password,
//                    isPasswordValid: $viewModel.isPasswordValid,
//                    passwordConfirmation: $viewModel.passwordConfirmation,
//                    isPasswordConfirmationValid: $viewModel.isPasswordConfirmationValid
//                )
//
//                Button("Restore") {
//                    Task {
//                        await viewModel.restore()
//                    }
//                }
//                .buttonStyle(.primary(isLoading: $viewModel.isRestoringWallet))
//                .enabled(if: viewModel.canProceed)
//
//            }
//            .disableAutocorrection(true)
//        }
//        .navigationTitle("Restore with private key")
//        #if DEBUG
//        .onAppear {
//            viewModel.password = unsafeDebugPassword
//            viewModel.passwordConfirmation = unsafeDebugPassword
//            // Some uninteresting test account without any balance.
//            viewModel.privateKeyHex = "0xcc7d1263009ebbc8e31f5b7e7d79b625e57cf489cd540e1b0ac4801c8daab9be"
//        }
//        #endif
    }
}

//extension InputField {
//    static func privateKey(
//        prompt: String = "Private Key",
//        text: Binding<String>,
//        isValid: Binding<Bool>? = nil
//    ) -> Self {
//        Self(
//            prompt: prompt,
//            text: text,
//            isValid: isValid,
//            isSecure: true,
//            maxLength: 66, // "0x" + 64 hex private key chars => max length 66.
//            characterRestriction: .onlyContains(whitelisted: .hexadecimalDigitsIncluding0x),
//            validationRules: [
//                Validation { privateKeyHex in
//                    if PrivateKey(hex: privateKeyHex) == nil {
//                        return "Invalid private key."
//                    }
//                    return nil // Valid
//                },
//            ]
//        )
//    }
//}
