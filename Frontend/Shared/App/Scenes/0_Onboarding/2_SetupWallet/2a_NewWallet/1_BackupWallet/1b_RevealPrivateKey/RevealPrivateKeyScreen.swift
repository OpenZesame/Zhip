//
//  RevealPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RevealPrivateKeyViewModel: ObservableObject {}

final class DefaultRevealPrivateKeyViewModel<Coordinator: BackupWalletCoordinator>: RevealPrivateKeyViewModel {
    private unowned let coordinator: Coordinator
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

struct RevealPrivateKeyScreen<ViewModel: RevealPrivateKeyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RevealPrivateKeyScreen {
    var body: some View {
        Text("Revealing private key")
    }
}
