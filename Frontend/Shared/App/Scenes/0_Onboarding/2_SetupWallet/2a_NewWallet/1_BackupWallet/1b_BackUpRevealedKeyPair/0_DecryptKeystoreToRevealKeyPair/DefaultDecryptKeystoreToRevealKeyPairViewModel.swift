//
//  DefaultDecryptKeystoreToRevealKeyPairViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation
import Combine
import ZhipEngine

// MARK: - DefaultDecryptKeystoreToRevealKeyPairViewModel
// MARK: -
final class DefaultDecryptKeystoreToRevealKeyPairViewModel<Coordinator: BackUpKeyPairCoordinator>: DecryptKeystoreToRevealKeyPairViewModel {
    
    @Published var password = ""
    @Published var isDecrypting = false
    @Published var isPasswordOnValidFormat = false
    @Published var canDecrypt = false
    
    private unowned let coordinator: Coordinator
    private let wallet: Wallet
    private let useCase: WalletUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, useCase: WalletUseCase, wallet: Wallet) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.wallet = wallet
        
        Publishers.CombineLatest(
            $isPasswordOnValidFormat,
            $isDecrypting.map { !$0 }
        ).map { (isPasswordValid, isNotDecrypting) in
            isPasswordValid && isNotDecrypting
        }.eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .assign(to: \.canDecrypt, on: self)
        .store(in: &cancellables)
    }
}

// MARK: - DecryptKeystoreToRevealKeyPairViewModel
// MARK: -
extension DefaultDecryptKeystoreToRevealKeyPairViewModel {
    func decrypt() async {
        precondition(isPasswordOnValidFormat)
        isDecrypting = true
        defer {
            Task { @MainActor in
                isDecrypting = false
            }
        }
        do {
            let keyPair = try await useCase.extractKeyPairFrom(
                keystore: wallet.keystore,
                encryptedBy: password
            )
            coordinator.didDecryptWallet(keyPair: keyPair)
        } catch {
            coordinator.failedToDecryptWallet(error: error)
        }
    }
}
