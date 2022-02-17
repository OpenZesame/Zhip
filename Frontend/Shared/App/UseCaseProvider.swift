//
//  UseCaseProvider.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation
import Zesame
import ZhipEngine

protocol UseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase
    func makeWalletUseCase() -> WalletUseCase
    
}

final class DefaultUseCaseProvider: UseCaseProvider {
   
    private let preferences: Preferences
    private let securePersistence: SecurePersistence
    private let zilliqaService: ZilliqaService
    
    init(
        preferences: Preferences = .default,
        securePersistence: SecurePersistence = .default,
        zilliqaService: ZilliqaService = DefaultZilliqaService.default
    ) {
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.zilliqaService = zilliqaService
    }
}

extension DefaultUseCaseProvider {
    static let shared: UseCaseProvider = DefaultUseCaseProvider()
}

extension DefaultUseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase {
        DefaultOnboardingUseCase(
            preferences: preferences,
            securePersistence: securePersistence
        )
    }
    
    func makeWalletUseCase() -> WalletUseCase {
        DefaultWalletUseCase(
            securePersistence: securePersistence,
            zilliqaService: zilliqaService
        )
    }
}
