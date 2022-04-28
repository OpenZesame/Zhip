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
import Styleguide
import Wallet
import WalletUnsafe

@main
struct BackUpWalletPreviewApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				BackUpWallet.Coordinator.View(
					store: Store(
						initialState: .fromOnboarding(wallet: .unsafe︕！Wallet),
						reducer: BackUpWallet.Coordinator.reducer,
						environment: BackUpWallet.Environment(
							backgroundQueue: DispatchQueue(label: "BackUpWalletPreviewApp-background-queue").eraseToAnyScheduler(),
							mainQueue: DispatchQueue.main.eraseToAnyScheduler()
						)
					)
				)
			}
			.zhipStyle()
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
