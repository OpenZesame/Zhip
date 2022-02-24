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

enum BackUpKeyPairCoordinatorNavigationStep {
    case failedToDecryptWallet(error: Swift.Error)
    case finishedBackingUpKeys
}

// MARK: - BackUpKeyPairCoordinator
// MARK: -
final class BackUpKeyPairCoordinator: NavigationCoordinatable {
    typealias Navigator = NavigationStepper<BackUpKeyPairCoordinatorNavigationStep>
    
    let stack = NavigationStack<BackUpKeyPairCoordinator>(initial: \.decryptKeystore)
    
    @Root var decryptKeystore = makeDecryptKeystore
    @Route(.push) var backUpRevealedKeyPair = makeBackUpRevealedKeyPair(keyPair:)
    
    private unowned let navigator: Navigator
    private let wallet: Wallet
    private let useCase: WalletUseCase
    
    private lazy var decryptKeystoreToRevealKeyPairNavigator = DecryptKeystoreToRevealKeyPairViewModel.Navigator()
    private lazy var backUpRevealedKeyPairNavigator = BackUpRevealedKeyPairViewModel.Navigator()
    
    init(navigator: Navigator, useCase: WalletUseCase, wallet: Wallet) {
        self.navigator = navigator
        self.useCase = useCase
        self.wallet = wallet
    }
    
    deinit {
        print("✅ BackUpKeyPairCoordinator DEINIT 💣")
    }
}


// MARK: - NavigationCoordinatable
// MARK: -
extension BackUpKeyPairCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(decryptKeystoreToRevealKeyPairNavigator) { [unowned self] userDid in
                switch userDid {
                case .failedToDecryptWallet(let error):
                    failedToDecryptWallet(error: error)
                case .didDecryptWallet(let keyPair):
                    didDecryptWallet(keyPair: keyPair)
                }
            }
            .onReceive(backUpRevealedKeyPairNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishBackingUpKeys:
                    doneBackingUpKeys()
                }
            }
            
    
    }
}

// MARK: - Routing
// MARK: -
extension BackUpKeyPairCoordinator {
    func toBackupRevealed(keyPair: KeyPair) {
        print("toBackupRevealed keypair: \(keyPair.publicKey.hex.uncompressed)")
        self.route(to: \.backUpRevealedKeyPair, keyPair)
    }
    
    func didDecryptWallet(keyPair: KeyPair) {
        toBackupRevealed(keyPair: keyPair)
    }
    
    func failedToDecryptWallet(error: Swift.Error) {
        navigator.step(.failedToDecryptWallet(error: error))
    }
    
    func doneBackingUpKeys() {
        navigator.step(.finishedBackingUpKeys)
    }
}

// MARK: - Factory
// MARK: -
private extension BackUpKeyPairCoordinator {

    @ViewBuilder
    func makeDecryptKeystore() -> some View {
        
        let viewModel = DecryptKeystoreToRevealKeyPairViewModel(
            navigator: decryptKeystoreToRevealKeyPairNavigator,
            useCase: useCase,
            wallet: wallet
        )
        
        DecryptKeystoreToRevealKeyPairScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeBackUpRevealedKeyPair(keyPair: KeyPair) -> some View {
        
        let viewModel = BackUpRevealedKeyPairViewModel(
            navigator: backUpRevealedKeyPairNavigator,
            keyPair: keyPair
        )
        
        BackUpRevealedKeyPairScreen(viewModel: viewModel)
    }
}
