// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
