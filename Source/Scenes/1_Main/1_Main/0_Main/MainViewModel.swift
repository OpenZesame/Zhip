//
//  MainViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa
import Zesame

// MARK: - MainUserAction
enum MainUserAction: TrackedUserAction {
    case send
    case receive
    case goToSettings
}

// MARK: - MainViewModel
private typealias € = L10n.Scene.Main
final class MainViewModel: BaseViewModel<
    MainUserAction,
    MainViewModel.InputFromView,
    MainViewModel.Output
> {

    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase
    private let updateBalanceTrigger: Driver<Void>

    // MARK: - Initialization
    init(transactionUseCase: TransactionsUseCase, walletUseCase: WalletUseCase, updateBalanceTrigger: Driver<Void>) {
        self.transactionUseCase = transactionUseCase
        self.walletUseCase = walletUseCase
        self.updateBalanceTrigger = updateBalanceTrigger
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let wallet = walletUseCase.wallet.filterNil().asDriverOnErrorReturnEmpty()

        let activityIndicator = ActivityIndicator()

        let fetchTrigger = Driver.merge(
            updateBalanceTrigger,
            input.fromView.pullToRefreshTrigger,
            wallet.mapToVoid()
        )

        let latestBalanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
            self.transactionUseCase
                .getBalance(for: $0.address)
                .trackActivity(activityIndicator)
                .asDriverOnErrorReturnEmpty()
                .do(onNext: { [unowned self] in self.transactionUseCase.cacheBalance($0.balance) })
        }

        // Format output
        let _cachedBalance: ZilAmount = transactionUseCase.cachedBalance ?? 0
        let latestBalanceOrZero = latestBalanceAndNonce.map { $0.balance }.startWith(_cachedBalance)

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .goToSettings) })
                .drive(),

            input.fromView.sendTrigger
                .do(onNext: { userIntends(to: .send) })
                .drive(),

            input.fromView.receiveTrigger
                .do(onNext: { userIntends(to: .receive) })
                .drive()
        ]

        let formatter = Formatter()

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            balance: latestBalanceOrZero.map { formatter.format(amount: $0) }
        )
    }
}

extension MainViewModel {
    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let receiveTrigger: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let balance: Driver<String>
    }

    struct Formatter {
        func format(amount: ZilAmount) -> String {
            return amount.formatted(unit: .zil)
        }
    }
}

extension ExpressibleByAmount {
    func formatted(unit: Zesame.Unit) -> String {
        return asString(in: unit).inserting(string: " ", every: 3)
    }
}
