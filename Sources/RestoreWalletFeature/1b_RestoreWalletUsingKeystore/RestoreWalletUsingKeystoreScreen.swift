//
//  RestoreWalletUsingKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Styleguide
import Screen
import InputField

public struct RestoreWalletUsingKeystoreScreen: View {
//    @ObservedObject var viewModel: RestoreWalletUsingKeystoreViewModel
}

// MARK: - View
// MARK: -
public extension RestoreWalletUsingKeystoreScreen {
    var body: some View {
        ForceFullScreen {
//            VStack {
//                TextEditor(text: $viewModel.keystoreString)
//                    .foregroundColor(Color.deepBlue)
//                    .font(.zhip.body)
//
//                if !viewModel.isKeystoreValid {
//                    Text("Invalid keystore")
//                        .foregroundColor(.bloodRed)
//                }
//
//                InputField.encryptionPassword(
//                    text: $viewModel.encryptionPassword,
//                    isValid: $viewModel.isEncryptionPasswordValid
//                )
//
//                Button("Restore") {
//                    Task {
//                        await viewModel.restore()
//                    }
//                }
//                .buttonStyle(.primary(isLoading: $viewModel.isRestoringWallet))
//                .enabled(if: viewModel.canProceed)
//            }
			Text("Code commented out")
        }
        .navigationTitle("Restore with keystore")
    }
}
