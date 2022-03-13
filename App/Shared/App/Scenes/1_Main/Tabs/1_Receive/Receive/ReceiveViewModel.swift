//
//  ReceiveViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import ZhipEngine
import Combine
import SwiftUI
import struct Zesame.Bech32Address
import QRCoding
import Wallet

public final class ReceiveViewModel: ObservableObject {
    
    @Published var myActiveAddressFormatted: String = "loading address"
    private var myActiveAddress: Bech32Address? {
        wallet?.bech32Address
    }
    @Published var qrCodeOfMyActiveAddress: Image? = nil

    private unowned let walletSubject: CurrentValueSubject<Wallet?, Never>
    private let walletUseCase: WalletUseCase
    
    // TODO: move to separate `ReceiveUseCase`
    private let qrCoding: QRCoding
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        walletUseCase: WalletUseCase,
        qrCoding: QRCoding = QRCoder()
    ) {
        self.qrCoding = qrCoding
        self.walletUseCase = walletUseCase
 
        self.walletSubject = walletUseCase.walletSubject
        
        subscribeToPublishers()
    }
}

private extension ReceiveViewModel {
    func subscribeToPublishers() {
        
        walletSubject
            .receive(on: RunLoop.main)
            .map { maybeWallet in
                if let wallet = maybeWallet {
                    return wallet.bech32Address.asString
                } else {
                    print("⚠️ WARNING no wallet configured?")
                    return "No wallet configured"
                }
            }
            .assign(to: \.myActiveAddressFormatted, on: self)
            .store(in: &cancellables)
        
        
        walletSubject
            .receive(on: RunLoop.main)
            .map { [unowned self] maybeWallet in
                guard let wallet = maybeWallet else {
                    return nil
                }
                return qrCoding.encode(
                    bech32Address: wallet.bech32Address
                    //                    , size: 600
                )

            }
            .assign(to: \.qrCodeOfMyActiveAddress, on: self)
            .store(in: &cancellables)
    }
    
    
    var wallet: Wallet? {
        walletSubject.value
    }
    
}
