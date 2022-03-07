//
//  UnlockAppWithPINScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-26.
//

import SwiftUI
import ZhipEngine

// MARK: - UnlockAppWithPINScreen
// MARK: -
struct UnlockAppWithPINScreen: View {
    @ObservedObject var viewModel: UnlockAppWithPINViewModel
}

// MARK: - View
// MARK: -
extension UnlockAppWithPINScreen {
    
    var body: some View {
        ForceFullScreen {
            VStack {
                PINField(
                    text: $viewModel.pinFieldText,
                    pinCode: $viewModel.pinCode,
                    errorMessage: viewModel.showError ? "Invalid PIN" : nil
                )
                
                Text("Unlock app with PIN or FaceId/TouchId")
                    .font(.zhip.body).foregroundColor(.silverGrey)
            }
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                if viewModel.isUserAllowedToCancel {
                    Button("Cancel") {
                        viewModel.cancel()
                    }
                }
            }
        }
        
    }
}
