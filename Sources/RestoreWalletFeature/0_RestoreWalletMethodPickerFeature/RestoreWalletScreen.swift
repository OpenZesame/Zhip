//
//  RestoreWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Styleguide
import Screen

public struct RestoreWalletScreen: View {
//    @ObservedObject var viewModel: RestoreWalletViewModel
}

// MARK: - View
// MARK: - 
public extension RestoreWalletScreen {
    var body: some View {
        ForceFullScreen {
//            VStack {
//                segmentedControl
//                contentView
//            }
//            .navigationTitle("Restore existing wallet")
			Text("Code commented out")
        }
    }
}

//private extension RestoreWalletScreen {
//    var segmentedControl: some View {
//        Picker(selection: $viewModel.restorationMethod, content: {
//            Text("Private key").tag(RestorationMethod.importPrivateKey)
//            Text("Keystore").tag(RestorationMethod.importKeystore)
//        }) {
//            EmptyView() // No label
//        }
//        .pickerStyle(.segmented)
//    }
//
//    @ViewBuilder
//    var contentView: some View {
//        switch viewModel.restorationMethod {
//        case .importKeystore:
//            RestoreWalletUsingKeystoreScreen(
//                viewModel: viewModel.restoreWalletUsingKeystoreViewModel
//            )
//        case .importPrivateKey:
//            RestoreWalletUsingPrivateKeyScreen(
//                viewModel: viewModel.restoreWalletUsingPrivateKeyViewModel
//            )
//        }
//    }
//}
