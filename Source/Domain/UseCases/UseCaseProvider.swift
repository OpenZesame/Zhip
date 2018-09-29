//
//  ChooseWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol UseCaseProvider {
    func makeChooseWalletUseCase() -> ChooseWalletUseCase
    func makeTransactionsUseCase() -> TransactionsUseCase
}
