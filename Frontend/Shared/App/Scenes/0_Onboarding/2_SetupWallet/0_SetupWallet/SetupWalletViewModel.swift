//
//  SetupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

protocol SetupWalletViewModel: ObservableObject {
    func generateNewWallet()
    func restoreExistingWallet()
}
