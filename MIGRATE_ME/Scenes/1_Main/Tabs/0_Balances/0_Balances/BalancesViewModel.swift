////
////  BalancesViewModel.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-24.
////
//
//import Foundation
//import ZhipEngine
//import Combine
//import Wallet
//import AmountFormatter
//
//public final class BalancesViewModel: ObservableObject {
//
//    @Published var zilBalance: String
//    @Published var isFetchingBalance: Bool = false
//
//    private unowned let walletSubject: CurrentValueSubject<Wallet?, Never>
//
//    private let walletUseCase: WalletUseCase
//    private let balancesUseCase: BalancesUseCase
//    private let amountFormatter: AmountFormatter
//
//    public init(
//        balancesUseCase: BalancesUseCase,
//        walletUseCase: WalletUseCase,
//        amountFormatter: AmountFormatter = .init()
//    ) {
//        self.balancesUseCase = balancesUseCase
//        self.walletUseCase = walletUseCase
//        self.amountFormatter = amountFormatter
//
//        self.walletSubject = walletUseCase.walletSubject
//
//        self.zilBalance = ""
//    }
//}
//
//public extension BalancesViewModel {
//
//    var myActiveAddress: String {
//        guard let wallet = wallet else {
//            return "No wallet configued"
//        }
//        return wallet.bech32Address.asString
//    }
//
//    func fetchBalanceFireAndForget() {
//        Task {
//            await fetchBalances()
//        }
//    }
//
//    func fetchBalances() async {
//        guard let wallet = wallet else {
//            return
//        }
//
//        Task { @MainActor [unowned self] in
//            isFetchingBalance = true
//        }
//
//        let zillingsBalance = await balancesUseCase.fetchBalance(
//            of: .zillings,
//            ownedBy: wallet.legacyAddress
//        )
//
//        Task { @MainActor [unowned self] in
//            isFetchingBalance = false
//            zilBalance = amountFormatter.format(
//                amount: zillingsBalance,
//                in: .zil,
//                formatThousands: true
//            )
//        }
//
//    }
//}
//
//private extension BalancesViewModel {
//
//    var wallet: Wallet? {
//        walletSubject.value
//    }
//
//}
