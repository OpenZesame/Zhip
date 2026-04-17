//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Zesame

// MARK: - MainUserAction

enum MainUserAction {
    case send
    case receive
    case goToSettings
}

// MARK: - MainViewModel

final class MainViewModel: BaseViewModel<
    MainUserAction,
    MainViewModel.InputFromView,
    MainViewModel.Output
> {
    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase
    private let updateBalanceTrigger: AnyPublisher<Void, Never>

    // MARK: - Initialization

    init(transactionUseCase: TransactionsUseCase, walletUseCase: WalletUseCase, updateBalanceTrigger: AnyPublisher<Void, Never>) {
        self.transactionUseCase = transactionUseCase
        self.walletUseCase = walletUseCase
        self.updateBalanceTrigger = updateBalanceTrigger
    }

    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let wallet = walletUseCase.wallet.filterNil().replaceErrorWithEmpty()

        let activityIndicator = ActivityIndicator()

        let fetchTrigger = Publishers.Merge3(updateBalanceTrigger, input.fromView.pullToRefreshTrigger, wallet.mapToVoid()).eraseToAnyPublisher()

        let latestBalanceAndNonce: AnyPublisher<BalanceResponse, Never> = fetchTrigger.withLatestFrom(wallet)
            .flatMapLatest { [unowned self] in
                transactionUseCase
                    .getBalance(for: $0.legacyAddress)
                    .trackActivity(activityIndicator)
                    .replaceErrorWithEmpty()
                    .handleEvents(receiveOutput: { [unowned self] in transactionUseCase.cacheBalance($0.balance) })
            }

        let balanceWasUpdatedAt = fetchTrigger.map { [unowned self] in
            transactionUseCase.balanceUpdatedAt
        }

        // Format output
        let _cachedBalance: Amount = transactionUseCase.cachedBalance ?? 0
        let latestBalanceOrZero = latestBalanceAndNonce.map(\.balance).prepend(_cachedBalance)

        [
            input.fromController.rightBarButtonTrigger
                .handleEvents(receiveOutput: { userIntends(to: .goToSettings) })
                .sink { _ in },

            input.fromView.sendTrigger
                .handleEvents(receiveOutput: { userIntends(to: .send) })
                .sink { _ in },

            input.fromView.receiveTrigger
                .handleEvents(receiveOutput: { userIntends(to: .receive) })
                .sink { _ in },

            transactionUseCase.getMinimumGasPrice().sink(receiveCompletion: { _ in }, receiveValue: { _ in }),
        ].forEach { $0.store(in: &cancellables) }

        let formatter = AmountFormatter()

        let refreshControlLastUpdatedTitle: AnyPublisher<String, Never> = balanceWasUpdatedAt.map {
            BalanceLastUpdatedFormatter().string(from: $0)
        }.eraseToAnyPublisher()

        return Output(
            isFetchingBalance: activityIndicator.asPublisher(),
            balance: latestBalanceOrZero.map { formatter.format(amount: $0, in: .zil, formatThousands: true) }.eraseToAnyPublisher(),
            refreshControlLastUpdatedTitle: refreshControlLastUpdatedTitle
        )
    }
}

extension MainViewModel {
    struct InputFromView {
        let pullToRefreshTrigger: AnyPublisher<Void, Never>
        let sendTrigger: AnyPublisher<Void, Never>
        let receiveTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let isFetchingBalance: AnyPublisher<Bool, Never>
        let balance: AnyPublisher<String, Never>
        let refreshControlLastUpdatedTitle: AnyPublisher<String, Never>
    }
}
