//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RestoreWalletUsingPrivateKeyViewModel: ObservableObject {}
final class DefaultRestoreWalletUsingPrivateKeyViewModel: RestoreWalletUsingPrivateKeyViewModel {}

struct RestoreWalletUsingPrivateKeyScreen<ViewModel: RestoreWalletUsingPrivateKeyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
        Text("Restore using privatekey")
    }
}
