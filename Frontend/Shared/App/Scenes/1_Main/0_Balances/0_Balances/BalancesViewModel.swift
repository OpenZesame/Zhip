//
//  BalancesViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-24.
//

import Foundation
import ZhipEngine

public final class BalancesViewModel: ObservableObject {
    
    @Published var myActiveAddress: String
    @Published var zilBalance: String
    
    
    private let wallet: Wallet

    private let walletUseCase: WalletUseCase
    private let balancesUseCase: BalancesUseCase
    private let amountFormatter: AmountFormatter
    
    public init(
        balancesUseCase: BalancesUseCase,
        walletUseCase: WalletUseCase,
        amountFormatter: AmountFormatter = .init()
    ) {
        self.balancesUseCase = balancesUseCase
        self.walletUseCase = walletUseCase
        self.amountFormatter = amountFormatter
        
        guard let wallet = walletUseCase.loadWallet() else {
            fatalError("TODO implement better handling of wallet, got none.")
        }
        self.wallet = wallet
        self.myActiveAddress = wallet.bech32Address.asString
        self.zilBalance = "Fetching..."
        
        subscribeToPublishers()
    }
}

public extension BalancesViewModel {
    
    func fetchBalanceFireAndForget() {
        Task {
            await fetchBalances()
        }
    }
    
    func fetchBalances() async {
        
        let zillingsBalance = await balancesUseCase.fetchBalance(
            of: .zillings,
            ownedBy: wallet.legacyAddress
        )
        
        Task { @MainActor [unowned self] in
            zilBalance = amountFormatter.format(
                amount: zillingsBalance,
                in: .zil,
                formatThousands: true
            )
        }
     
    }
}

private extension BalancesViewModel {
    func subscribeToPublishers() {
        
    }
}
