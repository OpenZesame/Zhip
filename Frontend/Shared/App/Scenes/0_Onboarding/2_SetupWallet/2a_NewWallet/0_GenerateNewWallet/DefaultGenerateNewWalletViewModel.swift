//
//  DefaultGenerateNewWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import Combine

final class DefaultGenerateNewWalletViewModel<Coordinator: NewWalletCoordinator>: GenerateNewWalletViewModel {
    
    private unowned let coordinator: Coordinator
    private let walletUseCase: WalletUseCase
    @Published var userHasConfirmedBackingUpPassword = false
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var isFinished = false
    @Published var isGeneratingWallet = false
        
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coordinator: Coordinator,
        useCase walletUseCase: WalletUseCase
    ) {
        self.coordinator = coordinator
        self.walletUseCase = walletUseCase
        
        canProceedPublisher
              .receive(on: RunLoop.main)
              .assign(to: \.isFinished, on: self)
              .store(in: &cancellables)
        
        #if DEBUG
        password = "apabanan"
        passwordConfirmation = password
        userHasConfirmedBackingUpPassword = true
        #endif
    }
    
    func `continue`() async {
        precondition(password == passwordConfirmation)
       
        isGeneratingWallet = true
        
        do {
            
            let wallet = try await walletUseCase.createNewWallet(
                name: "New Wallet",
                encryptionPassword: password
            )
            
            coordinator.didGenerateNew(wallet: wallet)
        } catch {
            coordinator.failedToGenerateNewWallet(error: error)
        }
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordConfirmation in
                return password == passwordConfirmation
            }
            .eraseToAnyPublisher()
    }
    
    private var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(arePasswordsEqualPublisher, $userHasConfirmedBackingUpPassword)
            .map { validPassword, userHasConfirmedBackingUpPassword in
                return validPassword && userHasConfirmedBackingUpPassword
            }
            .eraseToAnyPublisher()
    }
}
