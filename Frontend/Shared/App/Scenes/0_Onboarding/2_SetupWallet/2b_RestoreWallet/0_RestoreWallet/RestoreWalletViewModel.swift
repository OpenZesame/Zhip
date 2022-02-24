//
//  RestoreWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import ZhipEngine

// MARK: - RestorationMethod
// MARK: -
public enum RestorationMethod {
    case importKeystore
    case importPrivateKey
}

// MARK: - RestoreWalletNavigationStep
// MARK: -
public enum RestoreWalletNavigationStep {
    case restoreWallet(Wallet)
    case failedToRestoreWallet(error: Swift.Error)
}

// MARK: - RestoreWalletViewModel
// MARK: -
public final class RestoreWalletViewModel: ObservableObject {
    
    private unowned let navigator: Navigator
    @Published var restorationMethod: RestorationMethod = .importPrivateKey
    
    lazy var restoreWalletUsingKeystoreViewModel: RestoreWalletUsingKeystoreViewModel = makeRestoreWalletUsingKeystoreViewModel()
    
    lazy var restoreWalletUsingPrivateKeyViewModel: RestoreWalletUsingPrivateKeyViewModel = makeRestoreWalletUsingPrivateKeyViewModel()
    
    private let useCase: WalletUseCase
    
    public init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ RestoreWalletViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension RestoreWalletViewModel {
    typealias Navigator = NavigationStepper<RestoreWalletNavigationStep>
}

// MARK: - Private
// MARK: -
private extension RestoreWalletViewModel {
    func makeRestoreWalletUsingKeystoreViewModel() -> RestoreWalletUsingKeystoreViewModel {
        .init(
            navigator: navigator,
            useCase: useCase
        )
    }
    
    func makeRestoreWalletUsingPrivateKeyViewModel() -> RestoreWalletUsingPrivateKeyViewModel {
        .init(
            navigator: navigator,
            useCase: useCase
        )
    }
}
