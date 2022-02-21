//
//  NewPINCodeScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import ZhipEngine

// MARK: - NewPINCodeScreen
// MARK: -
struct NewPINCodeScreen<ViewModel: NewPINCodeViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension NewPINCodeScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                PINField(pinCode: $viewModel.pinCode)
                
                // ======= DELETE ME =======
                Group {
                    if let pin = viewModel.pinCode {
                        Text("PIN: '\(pin.digits.map({ String(describing: $0) }).joined(separator: ""))'")
                    } else {
                        Text("No pin set")
                    }
                }.font(.zhip.impression)
                Spacer()
                // ======= DELETE ME =======
                
                Text("The app PIN is an extra safety measure used only to unlock the app. It is not used to encrypt your private key. Before setting a PIN, back up the wallet, otherwise you might get locked out of your wallet if you forget the PIN.")
                
                Button("Done") {
                    viewModel.doneSettingPIN()
                }
                .buttonStyle(.primary)
                .enabled(if: viewModel.canProceed)
            }
            .navigationTitle("Set a PIN")
            .toolbar {
                Button("Skip") {
                    viewModel.skip()
                }
            }
        }
        
    }
}
