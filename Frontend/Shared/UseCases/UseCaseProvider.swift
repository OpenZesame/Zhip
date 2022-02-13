//
//  UseCaseProvider.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

protocol UseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase
    func makeWalletUseCase() -> WalletUseCase
    
}

final class DefaultUseCaseProvider: UseCaseProvider {
    init() {}
}

extension DefaultUseCaseProvider {
    static let shared: UseCaseProvider = DefaultUseCaseProvider(
        
    )
}

extension DefaultUseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase {
        fatalError()
    }
    
    func makeWalletUseCase() -> WalletUseCase {
        fatalError()
    }
}
