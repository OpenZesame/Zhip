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

final class DefaultUseCaseProvider {

    static let shared = DefaultUseCaseProvider(
        zilliqaService: DefaultZilliqaService.shared.rx,
        preferences: KeyValueStore(UserDefaults.standard)
    )

    private let zilliqaService: ZilliqaServiceReactive
    private let preferences: Preferences

    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
    }
}

extension DefaultUseCaseProvider: UseCaseProvider {
    func makeTransactionsUseCase() -> TransactionsUseCase {
        return DefaultTransactionsUseCase(zilliqaService: zilliqaService)
    }

    func makeOnboardingUseCase() -> OnboardingUseCase {
        return DefaultOnboardingUseCase(zilliqaService: zilliqaService, preferences: preferences)
    }
}
