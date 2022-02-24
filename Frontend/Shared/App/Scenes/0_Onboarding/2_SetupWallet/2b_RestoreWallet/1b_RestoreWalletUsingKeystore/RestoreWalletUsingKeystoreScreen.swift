//
//  RestoreWalletUsingKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RestoreWalletUsingKeystoreViewModel: ObservableObject {}

extension RestoreWalletUsingKeystoreViewModel {
    typealias Navigator = RestoreWalletViewModel.Navigator
}

final class DefaultRestoreWalletUsingKeystoreViewModel: RestoreWalletUsingKeystoreViewModel {
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    init(
        navigator: Navigator,
        useCase: WalletUseCase
    ) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ DefaultRestoreWalletUsingKeystoreViewModel deinit")
    }
}

struct RestoreWalletUsingKeystoreScreen<ViewModel: RestoreWalletUsingKeystoreViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingKeystoreScreen {
    var body: some View {
        ForceFullScreen {
            Text("Restore using keystore")
        }
    }
}
