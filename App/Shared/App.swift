//
//  ZhipApp.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import AppFeature
import ComposableArchitecture
import SwiftUI

@main
struct ZhipApp: App {
    
    let store = Store<AppState, AppAction>(
		initialState: .init(),
		reducer: appReducer,
		environment: .live
	)
    
    init() {
        #if os(iOS)
        // For NavigationBarTitle with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // For NavigationBarTitle with `displayMode = .inline`
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        #endif
        
//        appCoordinator = .init(
//            useCaseProvider: DefaultUseCaseProvider.shared,
//            appLifeCyclePublisher: appLifeCycleSubject.eraseToAnyPublisher()
//        )
    }
    
    var body: some Scene {
//        WindowGroup {
//           appCoordinator
//                .view()
//                .background(Color.appBackground)
//                .foregroundColor(.white)
//                .navigationBarTitleDisplayMode(.large)
//        }
//        .onChange(of: scenePhase) { newPhase in
//            appLifeCycleSubject.send(newPhase)
//        }
		WindowGroup {
			Text("Hej")
		}
    }
}

extension AppEnvironment {
	static var live: Self {
		.init(userDefaults: .live())
	}
}
