//
//  MainViewModel.swift
//  Zupreme
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
        }

        // Format output
        let latestBalanceOrZero = latestBalanceAndNonce.map { $0.balance }.startWith(Amount.maximum)

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
        func format(amount: Amount) -> String {

            func f(_ s: String) -> String {
                let new = s.inserting(string: "x", every: 3)
                print(new)
                return new
            }

            assert(f("1") == "1")
            assert(f("12") == "12")
            assert(f("123") == "123")
            assert(f("1234") == "1x234")
            assert(f("12345") == "12x345")
            assert(f("123456") == "123x456")
            assert(f("1234567") == "1x234x567")
            assert(f("12345678") == "12x345x678")
            assert(f("123456789") == "123x456x789")
            assert(f("123456789a") == "1x234x567x89a")

            return amount.display.inserting(string: "x", every: 3)
        }
//        func format(amount: Amount) -> String {
//            let amountFormatter = NumberFormatter()
//            amountFormatter.numberStyle = .currency
//            let number = NSNumber(value: Int(amount.significand))
//            guard let formattedAmount = amountFormatter.string(from: number) else {
//                log.error("Failed to format amount: `\(amount)` using NumberFormatter: `\(amountFormatter)`")
//                return amount.display
//            }
//            return formattedAmount
//        }
    }
}

extension String {
    func inserting(string: String, every interval: Int) -> String {
        return String.inserting(string: string, every: interval, in: self)
    }

//    static func insert(_ character: String, every interval: Int, in string: String) -> String {
//        var new = ""
//        var counter = 0
//
//        for index in string.indices {
//            defer {
//                counter = (counter + 1) % interval
//            }
//
//        }
//    }

    enum CharacterInsertionPlace {
        case end
    }

    static func inserting(string character: String, every interval: Int, in string: String, at insertionPlace: CharacterInsertionPlace = .end) -> String {
        guard string.count > interval else { return string }
        var string = string
        var new = ""

        switch insertionPlace {
        case .end:
            while let piece = string.droppingLast(interval) {
                let toAdd: String = string.isEmpty ? "" : character
                new = "\(toAdd)\(piece)\(new)"
            }
            if !string.isEmpty {
                new = "\(string)\(new)"
            }
        }

        return new
    }

    mutating func droppingLast(_ k: Int) -> String? {
        guard k <= count else { return nil }
        let string = String(suffix(k))
        removeLast(k)
        return string
    }
}
