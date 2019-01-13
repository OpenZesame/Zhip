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
                .delay(20, scheduler: MainScheduler.instance)
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
            guard let updatedAt = $0 else {
                return €.RefreshControl.first
            }

            return €.RefreshControl.balanceWasUpdatedAt(updatedAt.timeAgo().lowercased())
            }.do(onNext: { print("Refresh title: \($0)") })

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

extension Date {
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func timeAgo(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now

        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0

        switch (year, month, weekOfMonth, day, hour, minute, second) {
        case (let year, _, _, _, _, _, _) where year >= 2: return "\(year) years ago"
        case (let year, _, _, _, _, _, _) where year == 1: return numericDates ? "1 year ago" : "Last year"
        case (_, let month, _, _, _, _, _) where month >= 2: return "\(month) months ago"
        case (_, let month, _, _, _, _, _) where month == 1: return numericDates ? "1 month ago" :  "Last month"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) weeks ago"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1: return numericDates ? "1 week ago" : "Last week"
        case (_, _, _, let day, _, _, _) where day >= 2: return "\(day) days ago"
        case (_, _, _, let day, _, _, _) where day == 1: return numericDates ? "1 day ago" : "Yesterday"
        case (_, _, _, _, let hour, _, _) where hour >= 2: return "\(hour) hours ago"
        case (_, _, _, _, let hour, _, _) where hour == 1: return numericDates ? "1 hour ago" : "An hour ago"
        case (_, _, _, _, _, let minute, _) where minute >= 2: return "\(minute) minutes ago"
        case (_, _, _, _, _, let minute, _) where minute == 1: return numericDates ? "1 minute ago" : "A minute ago"
        case (_, _, _, _, _, _, let second) where second >= 3: return "\(second) seconds ago"
        default: return "Just now"
        }
    }
}
