//
//  NewPINPreviewApp.swift
//  NewPINPreview
//
//  Created by Alexander Cyon on 2022-04-11.
//

import ComposableArchitecture
import NewPINFeature
import ConfirmNewPINFeature
import PIN
import SwiftUI

@main
struct NewPINPreview: App {

	var body: some Scene {
		WindowGroup {
			NavigationView {
				NewPIN.CoordinatorScreen(
					store: Store(
						initialState: .init(),
						reducer: NewPIN.reducer.debug(),
						environment: NewPIN.Environment(
							keychainClient: .live(),
							mainQueue: DispatchQueue.main.eraseToAnyScheduler()
						)
					)
				)
				.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}
