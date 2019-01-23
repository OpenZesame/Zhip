//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import RxSwift
import RxCocoa
import Zesame

// MARK: - MainUserAction
enum MainUserAction: String, TrackedUserAction {
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

        let latestBalanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest { [unowned self] in
            self.transactionUseCase
                .getBalance(for: $0.address)
                .trackActivity(activityIndicator)
                .asDriverOnErrorReturnEmpty()
                .do(onNext: { [unowned self] in self.transactionUseCase.cacheBalance($0.balance) })
        }

        let balanceWasUpdatedAt = fetchTrigger.map { [unowned self] in
            self.transactionUseCase.balanceUpdatedAt
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

        let formatter = AmountFormatter()

        let refreshControlLastUpdatedTitle: Driver<String> = balanceWasUpdatedAt.map {
            BalanceLastUpdatedFormatter().string(from: $0)
        }

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            balance: latestBalanceOrZero.map { formatter.format(amount: $0, in: .zil) },
            refreshControlLastUpdatedTitle: refreshControlLastUpdatedTitle
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
        let refreshControlLastUpdatedTitle: Driver<String>
    }
}
