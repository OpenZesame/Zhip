//
//  NewPINCodeScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Styleguide
import Screen
import PINField

// MARK: - NewPINCodeScreen
// MARK: -
public struct NewPINCodeScreen: View {
//    @ObservedObject var viewModel: NewPINCodeViewModel
}

// MARK: - View
// MARK: -
public extension NewPINCodeScreen {
    var body: some View {
        ForceFullScreen {
//            VStack {
//                PINField(text: $viewModel.pinFieldText, pinCode: $viewModel.pinCode)
//
//                Text("The app PIN is an extra safety measure used only to unlock the app. It is not used to encrypt your private key. Before setting a PIN, back up the wallet, otherwise you might get locked out of your wallet if you forget the PIN.")
//                    .font(.zhip.body).foregroundColor(.silverGrey)
//
//                Button("Done") {
//                    viewModel.doneSettingPIN()
//                }
//                .buttonStyle(.primary)
//                .enabled(if: viewModel.canProceed)
//            }
//            .navigationTitle("Set a PIN")
//            .toolbar {
//                Button("Skip") {
//                    viewModel.skip()
//                }
//            }
			Text("Code commented out")
        }
        
    }
}
