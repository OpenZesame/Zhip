//
//  DefaultBackUpKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation
import ZhipEngine
import Combine

// MARK: - DefaultBackUpKeystoreViewModel
// MARK: -
final class DefaultBackUpKeystoreViewModel<Coordinator: BackupWalletCoordinator>: BackUpKeystoreViewModel {
    
    private unowned let coordinator: Coordinator
    private let wallet: Wallet
    
    @Published var isPresentingDidCopyKeystoreAlert = false
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, wallet: Wallet) {
        self.coordinator = coordinator
        self.wallet = wallet
        
        
        // Autoclose `Did Copy Keystore` Alert after delay
        $isPresentingDidCopyKeystoreAlert
            .filter { isPresenting in
                isPresenting
            }
            .delay(for: 2, scheduler: RunLoop.main) // dismiss after delay
            .map { _ in false } // `isPresentingDidCopyKeystoreAlert = false`
            .assign(to: \.isPresentingDidCopyKeystoreAlert, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - BackUpKeystoreViewModel
// MARK: -
extension DefaultBackUpKeystoreViewModel {
    func doneBackingUpKeystore() {
        coordinator.doneBackingUpKeystore()
    }
    
    var displayableKeystore: String { wallet.keystoreAsJSON }
    
    func copyKeystoreToPasteboard() {
        guard copyToPasteboard(contents: displayableKeystore) else { return }
        
        isPresentingDidCopyKeystoreAlert = true
    }
}
