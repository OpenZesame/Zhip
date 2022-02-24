//
//  DefaultRestoreWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

final class DefaultRestoreWalletViewModel: RestoreWalletViewModel {
    private unowned let navigator: Navigator
    @Published var restorationMethod: RestorationMethod = .importPrivateKey
    
    lazy var restoreWalletUsingKeystoreViewModel: DefaultRestoreWalletUsingKeystoreViewModel = makeRestoreWalletUsingKeystoreViewModel()
    
    lazy var restoreWalletUsingPrivateKeyViewModel: DefaultRestoreWalletUsingPrivateKeyViewModel = makeRestoreWalletUsingPrivateKeyViewModel()
    
    private let useCase: WalletUseCase
    
    init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ DefaultRestoreWalletViewModel deinit")
    }
}

// MARK: - RestoreWalletViewModel
// MARK: -
extension DefaultRestoreWalletViewModel {
    
}

// MARK: - Private
// MARK: -
private extension DefaultRestoreWalletViewModel {
    func makeRestoreWalletUsingKeystoreViewModel() -> DefaultRestoreWalletUsingKeystoreViewModel {
        .init(
            navigator: navigator,
            useCase: useCase
        )
    }
    
    func makeRestoreWalletUsingPrivateKeyViewModel() -> DefaultRestoreWalletUsingPrivateKeyViewModel {
        .init(
            navigator: navigator,
            useCase: useCase
        )
    }
}
