//
//  RestoreWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

protocol RestoreWalletViewModel: ObservableObject {}
final class DefaultRestoreWalletViewModel: RestoreWalletViewModel {
    private unowned let coordinator: RestoreWalletCoordinator
    init(coordinator: RestoreWalletCoordinator) {
        self.coordinator = coordinator
    }
}

struct RestoreWalletScreen<ViewModel: RestoreWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        Text("Restore Wallet")
    }
}
