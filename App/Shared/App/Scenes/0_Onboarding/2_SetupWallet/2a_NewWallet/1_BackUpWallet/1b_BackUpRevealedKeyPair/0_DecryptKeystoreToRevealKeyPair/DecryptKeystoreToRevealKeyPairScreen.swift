//
//  DecryptKeystoreToRevealKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import SwiftUI
import ZhipEngine
import Combine
import Styleguide
import Screen
import InputField

// MARK: - DecryptKeystoreToRevealKeyPairScreen
// MARK: -
struct DecryptKeystoreToRevealKeyPairScreen: View {
    @ObservedObject var viewModel: DecryptKeystoreToRevealKeyPairViewModel
}

// MARK: - View
// MARK: -
extension DecryptKeystoreToRevealKeyPairScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                
                Text("Enter your encryption password to reveal your private and public key.")
                
                InputField(
                    prompt: "Encryption password",
                    text: $viewModel.password,
                    isValid: $viewModel.isPasswordOnValidFormat,
                    isSecure: true,
                    validationRules: .encryptionPassword
                )
                
                Spacer()
                
                Button("Reveal") {
                    Task { @MainActor in
                        await viewModel.decrypt()
                    }
                }
                .disabled(!viewModel.canDecrypt)
                .buttonStyle(.primary(isLoading: $viewModel.isDecrypting))
            }
            .navigationTitle("Decrypt keystore")
        }
    }
}
