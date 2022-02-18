//
//  BackupWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI

protocol BackupWalletViewModel: ObservableObject {
    var userHasConfirmedBackingUpWallet: Bool { get set }
    var isFinished: Bool { get set }
    func `continue`()
    func copyKeystoreToPasteboard()
    func revealKeystore()
    func revealPrivateKey()
    var isPresentingDidCopyKeystoreSheet: Bool { get set }
}

final class DefaultBackupWalletViewModel<Coordinator: BackupWalletCoordinator>: BackupWalletViewModel {
    @Published var userHasConfirmedBackingUpWallet = false
    @Published var isFinished = false
    @Published var isPresentingDidCopyKeystoreSheet = false
    private unowned let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func `continue`() {
        fatalError()
    }
    
    func copyKeystoreToPasteboard() {
        let keystoreString = "This is a keystore string"
        #if iOS
        UIPasteboard.general.string = keystoreString
        #elseif macOS
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(keystoreString, forType: .string)
        #endif
    }
    
    func revealKeystore() {
        coordinator.revealKeystore()
    }
    
    func revealPrivateKey() {
        fatalError()
    }
}

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
        }.sheet(isPresented: $viewModel.isPresentingDidCopyKeystoreSheet, onDismiss: {
            print("dismissed did copy keystore sheet")
        }) {
            Text("Copied keystore.")
        }
    }
    
}

private let buttonWidth: CGFloat = 136
private extension BackupWalletScreen {
    @ViewBuilder
    var backupViews: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Private key").font(.zhip.title)
                Button("Reveal") {
                    viewModel.revealPrivateKey()
                }.frame(width: buttonWidth, height: 44).buttonStyle(.hollow)
            }
            VStack(alignment: .leading) {
                Text("Keystore").font(.zhip.title)
                HStack {
                    Button("Reveal") {
                        viewModel.revealKeystore()
                    }
                    .frame(width: buttonWidth)
                    .buttonStyle(.hollow)
                   
                    Button("Copy") {
                        viewModel.isPresentingDidCopyKeystoreSheet = true
                        viewModel.copyKeystoreToPasteboard()
                    }.frame(width: buttonWidth).buttonStyle(.hollow)
                }
            }
        }
    }
    
}
