//
//  SetupWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

protocol SetupWalletViewModel: ObservableObject {
    func generateNewWallet()
    func restoreExistingWallet()
}

final class DefaultSetupWalletViewModel: SetupWalletViewModel {
    private unowned let coordinator: SetupWalletCoordinator
    
    init(
        coordinator: SetupWalletCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    func generateNewWallet() {
        coordinator.generateNewWallet()
    }
    
    func restoreExistingWallet() {
        coordinator.restoreExistingWallet()
    }
}

struct SetupWalletScreen<ViewModel: SetupWalletViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Screen {
            foregroundView.background {
                backgroundView
            }
        }
        
    }
}

extension SetupWalletScreen {
    
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
    

