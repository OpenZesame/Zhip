//
//  ReceiveViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import ZhipEngine

public final class ReceiveViewModel: ObservableObject {
    
    @Published var myActiveAddress: String
    
    private let wallet: Wallet

    private let walletUseCase: WalletUseCase
    
    public init(
        walletUseCase: WalletUseCase
    ) {
        self.walletUseCase = walletUseCase
        
        guard let wallet = walletUseCase.loadWallet() else {
            fatalError("TODO implement better handling of wallet, got none.")
        }
        self.wallet = wallet
        self.myActiveAddress = wallet.bech32Address.asString
    }
}
