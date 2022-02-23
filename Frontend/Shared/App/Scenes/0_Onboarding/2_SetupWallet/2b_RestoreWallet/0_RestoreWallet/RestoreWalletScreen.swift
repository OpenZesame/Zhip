//
//  RestoreWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

struct RestoreWalletScreen<ViewModel: RestoreWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: - 
extension RestoreWalletScreen {
    var body: some View {
        Text("Restore Wallet")
    }
}
