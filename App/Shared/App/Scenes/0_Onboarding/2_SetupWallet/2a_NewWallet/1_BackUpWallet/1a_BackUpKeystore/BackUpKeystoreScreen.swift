//
//  RevealKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import Combine
import Styleguide

// MARK: - BackUpKeystoreScreen
// MARK: -
struct BackUpKeystoreScreen: View {
    @ObservedObject var viewModel: BackUpKeystoreViewModel
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
