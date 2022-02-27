//
//  RestoreWalletUsingKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-24.
//

import SwiftUI
import Combine
import Zesame
import ZhipEngine

// MARK: - RestoreWalletUsingKeystoreViewModel
// MARK: -
public final class RestoreWalletUsingKeystoreViewModel: BaseRestoreWalletViewModel {
    
    @Published var keystoreString: String = ""
    @Published var encryptionPassword: String = ""
    @Published var isEncryptionPasswordValid: Bool = false
    
    @Published var isKeystoreValid: Bool = false
    
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
        
        subscribeToPublishers()
    }
    
    deinit {
        print("☑️ RestoreWalletUsingKeystoreViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension RestoreWalletUsingKeystoreViewModel {
    typealias Navigator = RestoreWalletViewModel.Navigator
    
    var keyRestoration: KeyRestoration? {
        guard
            let keystore = Keystore(string: keystoreString)
        else {
            return nil
        }
        print("restoring keystore with password:\n\n\(encryptionPassword)\nkeystore\n\(keystore.asPrettyPrintedJSONString)\n\n")
        return KeyRestoration.keystore(keystore, password: encryptionPassword)
    }
    
    func restore() async {
        guard let keyRestoration = keyRestoration else {
            print("⚠️ No key restoration, invalid keystore or encryption password?")
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
private extension RestoreWalletUsingKeystoreViewModel {
    
    var isKeystoreValidPublisher: AnyPublisher<Bool, Never> {
        $keystoreString
            .map {
                Keystore(string: $0) != nil
            }.eraseToAnyPublisher()
    }
    
    var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isKeystoreValidPublisher,
            $isEncryptionPasswordValid
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
        
        isKeystoreValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isKeystoreValid, on: self)
            .store(in: &cancellables)
        
    }
}


private extension Keystore {
    init?(string: String) {
        guard let json = string.data(using: .utf8) else {
            return nil
        }

        do {
            self = try JSONDecoder().decode(Keystore.self, from: json)
        } catch {
           return nil
        }
    }
}
