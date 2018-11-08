//
//  DefaultUseCaseProvider.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame
import RxSwift
import KeychainSwift

final class DefaultUseCaseProvider {

    static let shared = DefaultUseCaseProvider(
        zilliqaService: DefaultZilliqaService.shared.rx,
        preferences: KeyValueStore(UserDefaults.standard),
        securePersistence: KeyValueStore(KeychainSwift())
    )

    private let zilliqaService: ZilliqaServiceReactive
    private let preferences: Preferences
    private let securePersistence: SecurePersistence

    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultUseCaseProvider: UseCaseProvider {
    func makeTransactionsUseCase() -> TransactionsUseCase {
        return DefaultTransactionsUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence)
    }

    func makeOnboardingUseCase() -> OnboardingUseCase {
        return DefaultOnboardingUseCase(zilliqaService: zilliqaService, preferences: preferences, securePersistence: securePersistence)
    }

    func makeWalletUseCase() -> WalletUseCase {
        return DefaultWalletUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence)
    }
}
