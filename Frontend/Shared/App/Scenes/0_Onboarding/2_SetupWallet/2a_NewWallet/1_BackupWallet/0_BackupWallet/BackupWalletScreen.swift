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
    var isPresentingDidCopyKeystoreAlert: Bool { get set }
}

import Combine
final class DefaultBackupWalletViewModel<Coordinator: BackupWalletCoordinator>: BackupWalletViewModel {
    @Published var userHasConfirmedBackingUpWallet = false
    @Published var isFinished = false
    @Published var isPresentingDidCopyKeystoreAlert = false
    private unowned let coordinator: Coordinator
    private let wallet: Wallet
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, wallet: Wallet) {
        self.coordinator = coordinator
        self.wallet = wallet
        
        // `userHasConfirmedBackingUpWallet` => `isFinished`
        $userHasConfirmedBackingUpWallet
            .assign(to: \.isFinished, on: self)
            .store(in: &cancellables)
        
        // Autoclose `Did Copy Keystore` Alert after delay
        $isPresentingDidCopyKeystoreAlert
        .filter { isPresenting in
            isPresenting
        }
        .delay(for: 2, scheduler: RunLoop.main) // dismiss after delay
        .map { _ in false } // `isPresentingDidCopyKeystoreAlert = false`
        .assign(to: \.isPresentingDidCopyKeystoreAlert, on: self)
        .store(in: &cancellables)
    }
    
    func `continue`() {
        coordinator.doneBackingUpWallet()
    }
    
    func copyKeystoreToPasteboard() {
        guard copyToPasteboard(contents: wallet.keystoreAsJSON) else { return }
        
        isPresentingDidCopyKeystoreAlert = true
    }
    
    func revealKeystore() {
        coordinator.revealKeystore()
    }
    
    func revealPrivateKey() {
        coordinator.revealPrivateKey()
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
        }
        .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
            Alert(
                title: Text("Copied keystore to pasteboard."),
                dismissButton: .default(Text("OK"))
            )
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
                            viewModel.copyKeystoreToPasteboard()
                    }.frame(width: buttonWidth).buttonStyle(.hollow)
                }
            }
        }
    }
    
}

import struct Zesame.Keystore
import ZhipEngine
extension Wallet {
    var keystoreAsJSON: String {
        return keystore.asPrettyPrintedJSONString
    }
}

extension Keystore {
    var asPrettyPrintedJSONString: String {
        guard let keystoreJSON = try? JSONEncoder(outputFormatting: .prettyPrinted).encode(self) else {
            incorrectImplementation("should be able to JSON encode a keystore")
        }
        guard let jsonString = String(data: keystoreJSON, encoding: .utf8) else {
            incorrectImplementation("Should be able to create JSON string from Data")
        }
        return jsonString
    }
}

func copyToPasteboard(contents: String) -> Bool {
    #if os(iOS)
    UIPasteboard.general.string = contents
    return true
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(contents, forType: .string)
    return true
    #else
    print("Unsupported platform, cannot copy to pasteboard.")
    return false
    #endif
}
