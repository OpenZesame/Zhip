//
//  BackUpRevealedKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

// MARK: - BackUpRevealedKeyPairScreen
// MARK: -
struct BackUpRevealedKeyPairScreen<ViewModel: BackUpRevealedKeyPairViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension BackUpRevealedKeyPairScreen {
    var body: some View {
        ForceFullScreen {
            VStack(alignment: .leading, spacing: 16) {
                Text("Private key")
                    .font(.zhip.title)
                    .foregroundColor(.white)
                
                Text("\(viewModel.displayablePrivateKey)")
                    .font(.zhip.body)
                    .textSelection(.enabled)
                    .foregroundColor(.white)
                
                Button("Copy") {
                    viewModel.copyPrivateKeyToPasteboard()
                }
                .buttonStyle(.hollow)
                
                Text("Public key (Uncompressed)")
                    .font(.zhip.title)
                    .foregroundColor(.white)
                
                Text("\(viewModel.displayablePublicKey)")
                    .font(.zhip.body)
                    .textSelection(.enabled)
                    .foregroundColor(.white)
                
                Button("Copy") {
                    viewModel.copyPublicKeyToPasteboard()
                }
                .buttonStyle(.hollow)
                
                Spacer()
            }
            .alert(isPresented: $viewModel.isPresentingDidCopyToPasteboardAlert) {
                Alert(
                    title: Text("Copied to pasteboard."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Back up keys")
        .toolbar {
            Button("Done") {
                viewModel.doneBackingUpKeys()
            }
        }
    }
}
