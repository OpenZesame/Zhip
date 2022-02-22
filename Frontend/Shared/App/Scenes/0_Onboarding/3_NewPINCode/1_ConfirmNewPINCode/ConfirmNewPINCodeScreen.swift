//
//  ConfirmNewPINCodeScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import SwiftUI
import ZhipEngine

// MARK: - ConfirmNewPINCodeScreen
// MARK: -
struct ConfirmNewPINCodeScreen<ViewModel: ConfirmNewPINCodeViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension ConfirmNewPINCodeScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                pinField
                
                Checkbox(
                    "I have securely backed up my PIN code",
                    isOn: $viewModel.userHasConfirmedBackingUpPIN
                )
                
                Button("Done") {
                    viewModel.continue()
                }
                .buttonStyle(.primary)
                .disabled(!viewModel.isFinished)
            }
            .navigationTitle("Confirm PIN")
            .toolbar {
                Button("Skip PIN") {
                    viewModel.skipSettingAnyPIN()
                }
            }
        }
        
    }
}

private extension ConfirmNewPINCodeScreen {
    var pinField: some View {
        PINField(text: $viewModel.pinFieldText, pinCode: $viewModel.pinCode, errorMessage: $viewModel.pinsDoNotMatchErrorMessage)
    }
}
