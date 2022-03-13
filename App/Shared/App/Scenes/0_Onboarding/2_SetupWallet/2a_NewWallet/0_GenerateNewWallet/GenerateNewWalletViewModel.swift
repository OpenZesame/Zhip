//
//  GenerateNewWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import Combine
import ZhipEngine
import Wallet

public class EncryptionPasswordSetting: ObservableObject {
    @Published var password = ""
    @Published var isPasswordValid = false
    @Published var passwordConfirmation = ""
    @Published var isPasswordConfirmationValid = false
}

internal extension EncryptionPasswordSetting {
    var _arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
       Publishers.CombineLatest($password, $passwordConfirmation)
           .debounce(for: 0.2, scheduler: RunLoop.main)
           .map { password, passwordConfirmation in
               return password == passwordConfirmation
           }
           .eraseToAnyPublisher()
   }
   
   var _arePasswordsValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest($isPasswordValid, $isPasswordConfirmationValid)
          .map { passwordValid, passwordConfirmationValid in
              return passwordValid && passwordConfirmationValid
          }
          .eraseToAnyPublisher()
  }
   
   var arePasswordsValidAndEqualPublisher: AnyPublisher<Bool, Never> {
       Publishers.CombineLatest(_arePasswordsEqualPublisher,_arePasswordsValidPublisher)
           .map { arePasswordsEqual, arePasswordsValid in
               return arePasswordsEqual && arePasswordsValid
           }
           .eraseToAnyPublisher()
   }
}

// MARK: - GenerateNewWalletNavigationStep
// MARK: -
public enum GenerateNewWalletNavigationStep {
    case didGenerateNew(wallet: Wallet)
    case failedToGenerateNewWallet(error: Swift.Error)
}

// MARK: - GenerateNewWalletNavigationStep
// MARK: -
public final class GenerateNewWalletViewModel: EncryptionPasswordSetting {
    
    @Published var userHasConfirmedBackingUpPassword = false
    @Published var canProceed = false
    @Published var isGeneratingWallet = false

    private unowned let navigator: Navigator
    private let walletUseCase: WalletUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        navigator: Navigator,
        useCase walletUseCase: WalletUseCase
    ) {
        self.navigator = navigator
        self.walletUseCase = walletUseCase
        super.init()
        
        subscribeToPublishers()
    }
    
    deinit {
        print("☑️ GenerateNewWalletViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension GenerateNewWalletViewModel {
    
    typealias Navigator = NavigationStepper<GenerateNewWalletNavigationStep>
    
    func `continue`() async {
        precondition(password == passwordConfirmation)
        isGeneratingWallet = true
        print("🔮 is generating wallet...")
        do {
            
            let wallet = try await walletUseCase.createNewWallet(
                name: "New Wallet",
                encryptionPassword: password
            )
            
            Task { @MainActor [unowned self] in
                print("✨ successfully created wallet")
                isGeneratingWallet = false
                navigator.step(.didGenerateNew(wallet: wallet))
            }
            
        } catch {
            Task { @MainActor [unowned self] in
                print("⚠️ failed to create wallet, error: \(error)")
                isGeneratingWallet = false
                navigator.step(.failedToGenerateNewWallet(error: error))
            }
            
        }
    }
}

// MARK: - Private
// MARK: -
private extension GenerateNewWalletViewModel {
    
    func subscribeToPublishers() {
        canProceedPublisher
              .receive(on: RunLoop.main)
              .assign(to: \.canProceed, on: self)
              .store(in: &cancellables)
    }
    
    var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(arePasswordsValidAndEqualPublisher, $userHasConfirmedBackingUpPassword)
            .map { arePasswordsValidAndEqual, userHasConfirmedBackingUpPassword in
                return arePasswordsValidAndEqual && userHasConfirmedBackingUpPassword
            }
            .eraseToAnyPublisher()
    }
}
