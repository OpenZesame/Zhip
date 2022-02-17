//
//  RestoreWalletUsingKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RestoreWalletUsingKeystoreViewModel: ObservableObject {}
final class DefaultRestoreWalletUsingKeystoreViewModel: RestoreWalletUsingKeystoreViewModel {}

struct RestoreWalletUsingKeystoreScreen<ViewModel: RestoreWalletUsingKeystoreViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingKeystoreScreen {
    var body: some View {
        Text("Restore using keystore")
    }
}
