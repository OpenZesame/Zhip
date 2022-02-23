//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

protocol RestoreWalletUsingPrivateKeyViewModel: ObservableObject {}

final class DefaultRestoreWalletUsingPrivateKeyViewModel: RestoreWalletUsingPrivateKeyViewModel {
    deinit {
        print("☑️ DefaultRestoreWalletUsingPrivateKeyViewModel deinit")
    }
}

struct RestoreWalletUsingPrivateKeyScreen<ViewModel: RestoreWalletUsingPrivateKeyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
        ForceFullScreen {
            Text("Restore using privatekey")
        }
    }
}
