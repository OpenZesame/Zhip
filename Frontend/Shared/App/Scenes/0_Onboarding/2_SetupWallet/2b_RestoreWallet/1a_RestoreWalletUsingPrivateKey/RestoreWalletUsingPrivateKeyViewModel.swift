//
//  RestoreWalletUsingPrivateKeyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-24.
//

import Foundation
import ZhipEngine
import Combine
import enum Zesame.KeyRestoration
import enum Zesame.KDF
import struct Zesame.KDFParams
import struct Zesame.PrivateKey

// MARK: - BaseRestoreWalletViewModel
// MARK: -
public protocol BaseRestoreWalletViewModel: ObservableObject {
    var canProceed: Bool { get set }
    var isRestoringWallet: Bool { get set }
    var keyRestoration: KeyRestoration? { get }
    func restore() async
}

public extension BaseRestoreWalletViewModel {
    
    var kdfParams: KDFParams {
#if DEBUG
        return .unsafeFast
#else
        return .default
#endif
    }
    
    var kdf: KDF {
#if DEBUG
        return .pbkdf2
#else
        return .scrypt
#endif
    }
}

// MARK: - RestoreWalletUsingPrivateKeyNavigationStep
// MARK: -
public enum RestoreWalletUsingPrivateKeyNavigationStep {
    case userDidRestoreWallet(Wallet)
    case failedToRestoreWallet(error: Error)
}

// MARK: - RestoreWalletUsingPrivateKeyViewModel
// MARK: -
public final class RestoreWalletUsingPrivateKeyViewModel: EncryptionPasswordSetting, BaseRestoreWalletViewModel {
    
    @Published var privateKeyHex: String = ""
    @Published var isPrivateKeyValid: Bool = false
    @Published public var canProceed: Bool = false
    @Published public var isRestoringWallet: Bool = false
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        navigator: Navigator,
        useCase: WalletUseCase
    ) {
        self.navigator = navigator
        self.useCase = useCase
        super.init()
        
        subscribeToPublishers()
    }
    
    deinit {
        print("☑️ RestoreWalletUsingPrivateKeyViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension RestoreWalletUsingPrivateKeyViewModel {
    
    typealias Navigator = RestoreWalletViewModel.Navigator
    
    var keyRestoration: KeyRestoration? {
        guard let privateKey = PrivateKey(hex: privateKeyHex) else {
            return nil
        }
        
        return KeyRestoration.privateKey(
            privateKey,
            encryptBy: password,
            kdf: kdf,
            kdfParams: kdfParams
        )
    }
    
    func restore() async {
        precondition(password == passwordConfirmation)
        guard let keyRestoration = keyRestoration else {
            print("⚠️ No key restoration, invalid private key hex?")
            return
        }
       
        Task { @MainActor [unowned self] in
            isRestoringWallet = true
        }
        
        do {
            let wallet = try await useCase.restoreWallet(name: "Wallet", from: keyRestoration)
            Task { @MainActor [unowned self] in
                isRestoringWallet = false
                navigator.step(.restoreWallet(wallet))
            }
        } catch {
            Task { @MainActor [unowned self] in
                isRestoringWallet = false
                navigator.step(.failedToRestoreWallet(error: error))
            }
        }
    }
}

// MARK: - Private
// MARK: -
private extension RestoreWalletUsingPrivateKeyViewModel {
    
    var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            arePasswordsValidAndEqualPublisher,
            $isPrivateKeyValid
        )
            .map { arePasswordsValidAndEqual, isPrivateKeyValid in
                return arePasswordsValidAndEqual && isPrivateKeyValid
            }
            .eraseToAnyPublisher()
    }
    
    func subscribeToPublishers() {
        canProceedPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.canProceed, on: self)
            .store(in: &cancellables)
    }
}
