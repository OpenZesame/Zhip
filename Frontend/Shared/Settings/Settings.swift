//
//  Settings.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject private var model: Model
    @State private var isAskingForDeleteWalletConfirmation: Bool = false
    var body: some View {
        VStack {
            Text("Settings")
            Button("Delete wallet") {
                isAskingForDeleteWalletConfirmation = true
            }
        }
        .alert(isPresented: $isAskingForDeleteWalletConfirmation) {
            Alert(
                title: Text("Really delete wallet?"),
                message: Text("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
                primaryButton: .destructive(Text("Delete")) {
                    model.deleteWallet()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
