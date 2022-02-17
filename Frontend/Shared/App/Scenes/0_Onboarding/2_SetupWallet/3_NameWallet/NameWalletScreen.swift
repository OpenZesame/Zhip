//
//  NameWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI

struct NameWalletScreen: View {

    @EnvironmentObject private var model: Model
    @State private var walletName: String = ""

    var body: some View {
        VStack {
            Text("Name wallet")
            
            TextField(
                walletName,
                text: $walletName,
                prompt: Text("Name of wallet")
            )
                .textFieldStyle(.roundedBorder)
            
            Button("Create new wallet") {
//                model.wallet = .init(name: walletName)
                fatalError("create new wallet here using UseCase but hmm in ViewModel")
            }
            .disabled(walletName.isEmpty)
        }
        .padding()
    }
}

