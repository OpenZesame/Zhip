//
//  BackUpWalletPreviewApp.swift
//  BackUpWalletPreview
//
//  Created by Alexander Cyon on 2022-04-11.
//

import BackUpWalletFeature
import ComposableArchitecture
import SwiftUI
import Wallet
#if DEBUG
import WalletUnsafe
#endif

@main
struct BackUpWalletPreviewApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				#if DEBUG
				BackUpWallet.CoordinatorScreen(
					store: Store(
						initialState: .init(wallet: .unsafe︕！Wallet),
						reducer: BackUpWallet.reducer,
						environment: BackUpWallet.Environment()
					)
				)
				#else
				Text("No preview for non DEBUG.")
				#endif
			}
        }
    }
}
