//
//  RestoreWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

protocol RestoreWalletViewModel: ObservableObject {}

final class DefaultRestoreWalletViewModel: RestoreWalletViewModel {
    private unowned let coordinator: RestoreWalletCoordinator
    init(coordinator: RestoreWalletCoordinator) {
        self.coordinator = coordinator
    }
}
