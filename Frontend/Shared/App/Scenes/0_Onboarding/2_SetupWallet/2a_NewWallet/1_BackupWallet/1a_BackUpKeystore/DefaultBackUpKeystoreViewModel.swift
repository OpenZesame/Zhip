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
final class DefaultBackUpKeystoreViewModel: BackUpKeystoreViewModel {
    
    private unowned let navigator: Navigator
    private let wallet: Wallet
    
    @Published var isPresentingDidCopyKeystoreAlert = false
    private var cancellables = Set<AnyCancellable>()
    
    init(navigator: Navigator, wallet: Wallet) {
        self.navigator = navigator
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
        navigator.step(.finishedBackingUpKeystore)
    }
    
    var displayableKeystore: String {
        wallet.keystoreAsJSON
    }
    
    func copyKeystoreToPasteboard() {
        guard copyToPasteboard(contents: displayableKeystore) else { return }
        
        isPresentingDidCopyKeystoreAlert = true
    }
}
