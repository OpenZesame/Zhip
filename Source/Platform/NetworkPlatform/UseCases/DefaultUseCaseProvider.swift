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

    static let shared = DefaultUseCaseProvider(zilliqaService: DefaultZilliqaService.shared.rx)

    private let zilliqaService: ZilliqaServiceReactive

    init(zilliqaService: ZilliqaServiceReactive) {
        self.zilliqaService = zilliqaService
    }
}

extension DefaultUseCaseProvider: UseCaseProvider {
    func makeChooseWalletUseCase() -> ChooseWalletUseCase {
        return DefaultChooseWalletUseCase(zilliqaService: zilliqaService)
    }

    func makeTransactionsUseCase() -> TransactionsUseCase {
        return DefaultTransactionsUseCase(zilliqaService: zilliqaService)
    }
}
