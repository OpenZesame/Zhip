//
//  NameWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI

protocol NameWalletViewModel: ObservableObject {
    var walletName: String { get set }
    var isNameValid: Bool { get set }
}

final class DefaultNameWalletViewModel: NameWalletViewModel {
    @Published var walletName = ""
    @Published var isNameValid = false
}

struct NameWalletScreen<ViewModel: NameWalletViewModel>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("Name wallet")
            
            TextField(
                viewModel.walletName,
                text: $viewModel.walletName,
                prompt: Text("Name of wallet")
            )
                .textFieldStyle(.roundedBorder)
            
            Button("Create new wallet") {
                //                model.wallet = .init(name: walletName)
                fatalError("create new wallet here using UseCase but hmm in ViewModel")
            }
            .disabled(viewModel.isNameValid)
        }
        .padding()
    }
}

