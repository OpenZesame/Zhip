//
//  Balance.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI
import ZhipEngine

struct Balances: View {
    @EnvironmentObject private var wallet: Wallet
    var body: some View {
        Text("Balances in wallet: \(wallet.name)")
    }
}
