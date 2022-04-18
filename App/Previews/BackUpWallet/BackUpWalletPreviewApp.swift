//
//  BackUpWalletPreviewApp.swift
//  BackUpWalletPreview
//
//  Created by Alexander Cyon on 2022-04-11.
//

import SwiftUI

#if DEBUG
import BackUpWalletFeature
import ComposableArchitecture
import Wallet
import WalletUnsafe

@main
struct BackUpWalletPreviewApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				BackUpWallet.CoordinatorScreen(
					store: Store(
						initialState: .init(wallet: Wallet.unsafe︕！Wallet),
						reducer: BackUpWallet.reducer,
						environment: .init()
					)
				)
			}
			
        }
    }
}
#else

@main
struct BackUpWalletPreviewApp: App {
	var body: some Scene {
		WindowGroup {
			Text("Only supported in DEBUG mode.")
		}
	}
}
#endif // DEBUG
