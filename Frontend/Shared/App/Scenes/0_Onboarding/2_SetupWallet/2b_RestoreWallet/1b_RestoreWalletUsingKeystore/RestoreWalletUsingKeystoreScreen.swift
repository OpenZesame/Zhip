//
//  RestoreWalletUsingKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

struct RestoreWalletUsingKeystoreScreen: View {
    @ObservedObject var viewModel: RestoreWalletUsingKeystoreViewModel
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
