//
//  SetupWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

struct SetupWalletScreen<ViewModel: SetupWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension SetupWalletScreen {
    var body: some View {
        Screen {
            foregroundView.background {
                backgroundView
            }
        }
        
    }
}

private extension SetupWalletScreen {
    
    var foregroundView: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Wallet").font(.largeTitle)
                Text("It is time to set up the wallet. Do you want to start fresh, or restore an existing")
            }
           
            VStack {
                Button("Generate new") {
                    viewModel.generateNewWallet()
                }
                .buttonStyle(.primary)
                
                Button("Restore existing") {
                    viewModel.restoreExistingWallet()
                }
                .buttonStyle(.secondary)
            }
        }
        .padding()
    }
  
    
    var backgroundView: some View {
        ParallaxImage(
            back: "Images/ChooseWallet/BackAbyss",
            middle: "Images/ChooseWallet/MiddleStars",
            front: "Images/ChooseWallet/FrontPlanets"
        )
    }
}
    

