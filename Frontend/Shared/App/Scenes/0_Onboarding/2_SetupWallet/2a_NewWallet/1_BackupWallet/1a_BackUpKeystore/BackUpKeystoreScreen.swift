//
//  RevealKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import Combine

// MARK: - BackUpKeystoreScreen
// MARK: -
struct BackUpKeystoreScreen<ViewModel: BackUpKeystoreViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension BackUpKeystoreScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                ScrollView {
                    Text(viewModel.displayableKeystore)
                        .textSelection(.enabled)
                }
                Button("Copy keystore") {
                    viewModel.copyKeystoreToPasteboard()
                }
                .buttonStyle(.primary)
            }
            .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
                Alert(
                    title: Text("Copied keystore to pasteboard."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Back up keystore")
        .toolbar {
            Button("Done") {
                viewModel.doneBackingUpKeystore()
            }
        }
    }
}