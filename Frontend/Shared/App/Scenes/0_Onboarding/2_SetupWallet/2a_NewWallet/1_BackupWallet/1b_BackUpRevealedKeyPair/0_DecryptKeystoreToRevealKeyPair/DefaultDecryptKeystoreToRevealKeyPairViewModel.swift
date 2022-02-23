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
final class DefaultDecryptKeystoreToRevealKeyPairViewModel: DecryptKeystoreToRevealKeyPairViewModel {
    
    @Published var password = ""
    @Published var isDecrypting = false
    @Published var isPasswordOnValidFormat = false
    @Published var canDecrypt = false
    
    private unowned let navigator: Navigator
    private let wallet: Wallet
    private let useCase: WalletUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigator: Navigator, useCase: WalletUseCase, wallet: Wallet) {
        self.navigator = navigator
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
        
        do {
            let keyPair = try await useCase.extractKeyPairFrom(
                keystore: wallet.keystore,
                encryptedBy: password
            )
            Task { @MainActor [unowned self] in
                print("✅ decrypted keypair")
                isDecrypting = false
                navigator.step(.didDecryptWallet(keyPair: keyPair))
            }
        } catch {
            Task { @MainActor [unowned self] in
                print("⚠️ failed to decrypt wallet, wrong password? Error: \(error)")
                isDecrypting = false
                navigator.step(.failedToDecryptWallet(error: error))
            }
        }
    }
}
