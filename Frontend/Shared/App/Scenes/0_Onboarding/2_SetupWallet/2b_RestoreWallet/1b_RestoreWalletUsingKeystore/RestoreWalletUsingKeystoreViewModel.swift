//
//  RestoreWalletUsingKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-24.
//

import SwiftUI

// MARK: - RestoreWalletUsingKeystoreViewModel
// MARK: -
public final class RestoreWalletUsingKeystoreViewModel: ObservableObject {
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    public init(
        navigator: Navigator,
        useCase: WalletUseCase
    ) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ RestoreWalletUsingKeystoreViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension RestoreWalletUsingKeystoreViewModel {
    typealias Navigator = RestoreWalletViewModel.Navigator
}
