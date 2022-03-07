//
//  BalancesUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import Zesame

public enum Asset {
    case zillings
    case token(contractAddress: Bech32Address)
}

public protocol BalancesUseCase {
    
    func fetchBalance(
        of asset: Asset,
        ownedBy owner: LegacyAddress
    ) async -> ZilAmount
    
    var balanceUpdatedAt: Date? { get }
}


public final class DefaultBalancesUseCase: BalancesUseCase {
    
    private let zilliqaService: ZilliqaService
    private let securePersistence: SecurePersistence
    private let preferences: Preferences

    public init(
        zilliqaService: ZilliqaService,
        securePersistence: SecurePersistence,
        preferences: Preferences
    ) {
        self.zilliqaService = zilliqaService
        self.securePersistence = securePersistence
        self.preferences = preferences
    }
}

private extension DefaultBalancesUseCase {
    func balanceWasUpdated(at date: Date) {
        try! preferences.save(value: date, for: .balanceWasUpdatedAt)
    }
    
    func cacheZillingsBalance(_ balance: ZilAmount) {
        try! securePersistence.save(value: balance.qaString, for: .cachedZillingBalance)
        balanceWasUpdated(at: Date())
    }
    
    func fetchZillingBalance(
        for owner: LegacyAddress
    ) async -> ZilAmount {
        defer {
            balanceWasUpdated(at: Date.now)
        }
        do {
            return try await zilliqaService.getBalance(for: owner).balance
        } catch {
            return cachedBalance ?? ZilAmount(0)
        }

    }
}

public extension DefaultBalancesUseCase {

    var cachedBalance: ZilAmount? {
        guard let qa: String = try! securePersistence.loadValue(for: .cachedZillingBalance) else {
            return nil
        }
        return try! ZilAmount(qa: qa)
    }

    var balanceUpdatedAt: Date? {
        try! preferences.loadValue(for: .balanceWasUpdatedAt)
    }


    func fetchBalance(
        of asset: Asset,
        ownedBy owner: LegacyAddress
    ) async -> ZilAmount {
        switch asset {
        case .zillings:
            return await fetchZillingBalance(for: owner)
        case .token(let tokenContractAddress):
            fatalError("Have not yet implemented Zilliqa token balance fetching. Cannot fetch balance of token with contact address: \(tokenContractAddress).")
        }
    }

}

public protocol TransactionUseCase {
    func getMinimumGasPrice() async -> ZilAmount
}

public final class DefaultTransactionUseCase: TransactionUseCase {
    private let zilliqaService: ZilliqaService
    public init(zilliqaService: ZilliqaService) {
        self.zilliqaService = zilliqaService
    }
}


public extension DefaultTransactionUseCase {
    func getMinimumGasPrice() async -> ZilAmount {
        try! await zilliqaService.getMinimumGasPrice(alsoUpdateLocallyCachedMinimum: true).amount
    }
}
