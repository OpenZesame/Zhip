//
//  RevealKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RevealKeystoreViewModel: ObservableObject {}
final class DefaultRevealKeystoreViewModel<Coordinator: BackupWalletCoordinator>: RevealKeystoreViewModel {
    private unowned let coordinator: Coordinator
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

struct RevealKeystoreScreen<ViewModel: RevealKeystoreViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RevealKeystoreScreen {
    var body: some View {
        Text("Revealing keystore")
    }
}
