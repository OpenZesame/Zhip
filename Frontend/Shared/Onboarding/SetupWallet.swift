//
//  SetupWallet.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI

struct SetupWallet: View {

    @EnvironmentObject private var model: Model
    @State private var walletName: String = ""

    var body: some View {
        VStack {
            Text("Setup wallet")
            
            TextField(
                walletName,
                text: $walletName,
                prompt: Text("Name of wallet")
            )
                .textFieldStyle(.roundedBorder)
            
            Button("Create new wallet") {
                model.configuredNewWallet(.init(name: walletName))
            }
            .disabled(walletName.isEmpty)
        }
        .padding()
    }
}

