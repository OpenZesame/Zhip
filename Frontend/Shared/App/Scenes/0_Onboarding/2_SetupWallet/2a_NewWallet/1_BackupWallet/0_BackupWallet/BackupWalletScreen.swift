//
//  BackupWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI

// MARK: - BackupWalletScreen
// MARK: -
struct BackupWalletScreen<ViewModel: BackupWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension BackupWalletScreen {
    
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 16) {
           
                Labels(
                    title: "Back up keys",
                    subtitle: "Backing up the private key is the most important, but is also the most sensitive data. The private key is not tied to the encryption password, but the keystore is. Failing to backup your wallet may result in irrevesible loss of assets."
                )
                
                backupViews.frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Checkbox(
                    "I have securely backed up my private key.",
                    isOn: $viewModel.userHasConfirmedBackingUpWallet
                )
                
                Button("Continue") {
                    viewModel.continue()
                }
                .buttonStyle(.primary)
                .disabled(!viewModel.isFinished)
            }
        }
        .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
            Alert(
                title: Text("Copied keystore to pasteboard."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

// MARK: - Subviews
// MARK: -
private extension BackupWalletScreen {
    @ViewBuilder
    var backupViews: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Private key").font(.zhip.title)
                HStack {
                    Button("Reveal") {
                        viewModel.revealPrivateKey()
                    }.buttonStyle(.hollow)
                    Spacer()
                }
            }
            VStack(alignment: .leading) {
                Text("Keystore").font(.zhip.title)
                HStack {
                    Button("Reveal") {
                        viewModel.revealKeystore()
                    }
                    .buttonStyle(.hollow)
                    
                    Button("Copy") {
                        viewModel.copyKeystoreToPasteboard()
                    }.buttonStyle(.hollow)
                    
                    Spacer()
                }
            }
        }
    }
    
}
