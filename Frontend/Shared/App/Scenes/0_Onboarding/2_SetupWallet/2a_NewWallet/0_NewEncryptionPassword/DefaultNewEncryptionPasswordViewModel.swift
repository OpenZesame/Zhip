//
//  DefaultNewEncryptionPasswordViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import Combine

final class DefaultNewEncryptionPasswordViewModel: NewEncryptionPasswordViewModel {
    
    private unowned let coordinator: NewWalletCoordinator
    private let walletUseCase: WalletUseCase
    @Published var userHasConfirmedBackingUpPassword = false
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var isFinished = false
        
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coordinator: NewWalletCoordinator,
        useCase walletUseCase: WalletUseCase
    ) {
        self.coordinator = coordinator
        self.walletUseCase = walletUseCase
        
        canProceedPublisher
              .receive(on: RunLoop.main)
              .assign(to: \.isFinished, on: self)
              .store(in: &cancellables)
    }
    
    func `continue`() {
        coordinator.encryptionPasswordIsSet()
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
