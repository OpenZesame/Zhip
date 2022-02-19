//
//  DefaultBackUpRevealedKeyPairViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation
import Combine
import Zesame

// MARK: - DefaultBackUpRevealedKeyPairViewModel
// MARK: -
final class DefaultBackUpRevealedKeyPairViewModel<Coordinator: BackUpKeyPairCoordinator>: BackUpRevealedKeyPairViewModel {
    
    @Published var isPresentingDidCopyToPasteboardAlert = false
    private unowned let coordinator: Coordinator
    private let keyPair: KeyPair
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, keyPair: KeyPair) {
        self.coordinator = coordinator
        self.keyPair = keyPair
        
        // Autoclose `Did Copy Keystore` Alert after delay
        $isPresentingDidCopyToPasteboardAlert
        .filter { isPresenting in
            isPresenting
        }
        .delay(for: 2, scheduler: RunLoop.main) // dismiss after delay
        .map { _ in false } // `isPresentingDidCopyKeystoreAlert = false`
        .assign(to: \.isPresentingDidCopyToPasteboardAlert, on: self)
        .store(in: &cancellables)
    }
}

// MARK: - BackUpRevealedKeyPairViewModel
// MARK: -
extension DefaultBackUpRevealedKeyPairViewModel {
    var displayablePrivateKey: String {
        keyPair.privateKey.asHex().lowercased()
    }
    
    var displayablePublicKey: String {
        keyPair.publicKey.hex.uncompressed.lowercased()
    }
    
    func copyPrivateKeyToPasteboard() {
        guard copyToPasteboard(contents: displayablePrivateKey) else {
            return
        }
        isPresentingDidCopyToPasteboardAlert = true
    }
    
    func copyPublicKeyToPasteboard() {
        guard copyToPasteboard(contents: displayablePublicKey) else {
            return
        }
        isPresentingDidCopyToPasteboardAlert = true
    }
    
    func doneBackingUpKeys() {
        coordinator.doneBackingUpKeys()
    }
}
