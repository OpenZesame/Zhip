//
//  SettingsScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var viewModel: SettingsViewModel
}

// MARK: - View
// MARK: -
extension SettingsScreen {
    
    var body: some View {
        Screen {
            VStack {
                Text("Settings")
                Button("Delete wallet") {
                    viewModel.askForDeleteWalletConfirmation()
                }.buttonStyle(.primary)
            }
            .alert(isPresented: $viewModel.isAskingForDeleteWalletConfirmation) {
                Alert(
                    title: Text("Really delete wallet?"),
                    message: Text("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.confirmWalletDeletion()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
