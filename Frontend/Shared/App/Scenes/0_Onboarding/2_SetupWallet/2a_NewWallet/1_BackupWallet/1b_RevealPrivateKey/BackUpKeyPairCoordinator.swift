//
//  BackUpKeyPairCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import Stinsen
import Foundation
import SwiftUI
import ZhipEngine
import struct Zesame.KeyPair

protocol BackUpKeyPairCoordinator: AnyObject {
    func didDecryptWallet(keyPair: KeyPair)
    func failedToDecryptWallet(error: Swift.Error)
    func doneBackingUpKeys()
}

final class DefaultBackUpKeyPairCoordinator: BackUpKeyPairCoordinator, NavigationCoordinatable {
    
    let stack = NavigationStack<DefaultBackUpKeyPairCoordinator>(initial: \.decryptKeystore)
    
    @Root var decryptKeystore = makeDecryptKeystore
    @Route(.push) var backUpRevealedKeyPair = makeBackUpRevealedKeyPair(keyPair:)
    
    private let wallet: Wallet
    private let useCase: WalletUseCase
    
    init(useCase: WalletUseCase, wallet: Wallet) {
        self.useCase = useCase
        self.wallet = wallet
    }
}

// MARK: - BackUpKeyPairCoordinator
// MARK: -
extension DefaultBackUpKeyPairCoordinator {
    func didDecryptWallet(keyPair: KeyPair) {
        toBackupRevealed(keyPair: keyPair)
    }
    
    func failedToDecryptWallet(error: Swift.Error) {
        print("Failed to decrypt wallet, error: \(error)")
        
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
    
    func doneBackingUpKeys() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}

// MARK: - Routing
// MARK: -
extension DefaultBackUpKeyPairCoordinator {
    func toBackupRevealed(keyPair: KeyPair) {
        print("toBackupRevealed keypair: \(keyPair.publicKey.hex.uncompressed)")
        self.route(to: \.backUpRevealedKeyPair, keyPair)
    }
}

// MARK: - Factory
// MARK: -
private extension DefaultBackUpKeyPairCoordinator {

    @ViewBuilder
    func makeDecryptKeystore() -> some View {
        
        let viewModel = DefaultDecryptKeystoreToRevealKeyPairViewModel(
            coordinator: self,
            useCase: useCase,
            wallet: wallet
        )
        
        DecryptKeystoreToRevealKeyPairScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeBackUpRevealedKeyPair(keyPair: KeyPair) -> some View {
        let viewModel = DefaultBackUpRevealedKeyPairViewModel(coordinator: self, keyPair: keyPair)
        BackUpRevealedKeyPairScreen(viewModel: viewModel)
    }
}
