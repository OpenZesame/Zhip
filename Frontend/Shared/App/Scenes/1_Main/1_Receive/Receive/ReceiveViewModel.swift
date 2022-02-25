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

public final class ReceiveViewModel: ObservableObject {
    
    @Published var myActiveAddressFormatted: String = "loading address"
    @Published private var myActiveAddress: Bech32Address
    @Published var qrCodeOfMyActiveAddress: Image = Image(systemName: "arrow.down")
    
    private let wallet: Wallet

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
        
        guard let wallet = walletUseCase.loadWallet() else {
            fatalError("TODO implement better handling of wallet, got none.")
        }
        self.wallet = wallet
        self.myActiveAddress = wallet.bech32Address
        
        subscribeToPublishers()
    }
}

private extension ReceiveViewModel {
    func subscribeToPublishers() {
        
        $myActiveAddress
            .receive(on: RunLoop.main)
            .map { $0.asString }
            .assign(to: \.myActiveAddressFormatted, on: self)
            .store(in: &cancellables)
        
        
        $myActiveAddress
            .receive(on: RunLoop.main)
            .compactMap { [unowned self] in
                qrCoding.encode(
                    bech32Address: $0
//                    , size: 600
                )
            }
            .assign(to: \.qrCodeOfMyActiveAddress, on: self)
            .store(in: &cancellables)
    }
}
