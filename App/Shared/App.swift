//
//  ZhipApp.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import AppFeature
import ComposableArchitecture
import Styleguide
import SwiftUI
import WalletGenerator
import WalletGeneratorLive
import WalletRestorer
import WalletRestorerLive

typealias App = AppFeature.App
typealias AppProtocol = SwiftUI.App


#if DEBUG
import WalletGeneratorUnsafeFast
#endif // DEBUG

#if DEBUG
import WalletRestorerUnsafeFast
#endif // DEBUG


private func makeAppStore() -> Store<App.State, App.Action> {
	.init(
		initialState: .init(),
		reducer: App.reducer,
		environment: .live
	)
}

private func makeViewStore(from store: Store<App.State, App.Action>) -> ViewStore<Void, App.Action> {
	ViewStore(
		store.scope(state: { _ in () }),
		removeDuplicates: ==
	)
}

#if os(iOS)
final class AppDelegate: NSObject, UIApplicationDelegate {
	let store = makeAppStore()
	
	lazy var viewStore = makeViewStore(from: store)

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		viewStore.send(.appDelegate(.didFinishLaunching))
		return true
	}

	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		viewStore.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
	}

	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error
	) {
		viewStore.send(
			.appDelegate(.didRegisterForRemoteNotifications(.failure(error as NSError)))
		)
	}
}
#endif


@main
struct ZhipApp: AppProtocol {
	#if os(iOS)
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	#else
	let _store: Store<AppState, AppAction>
	let _viewStore: ViewStore<Void, AppAction>
	#endif

	@Environment(\.scenePhase) private var scenePhase
	
    init() {
		Styleguide.install()
		#if os(macOS)
		self.store = makeAppStore()
		self.viewStore = makeViewStore(from: self.store)
		#endif
    }
    
    var body: some Scene {
		WindowGroup {
			App.View(store: store)
				.background(Color.appBackground)
				.foregroundColor(.white)
			#if os(iOS)
				.navigationBarTitleDisplayMode(.inline)
			#endif
		}
		.onChange(of: scenePhase) {
			viewStore.send(.didChangeScenePhase($0))
		}
    }
}

extension ZhipApp {
	var store: Store<App.State, App.Action> {
		#if os(iOS)
		appDelegate.store
		#else
		_store
		#endif
	}
	
	var viewStore: ViewStore<Void, App.Action> {
		#if os(iOS)
		appDelegate.viewStore
		#else
		_viewStore
		#endif
	}
}


extension App.Environment {
	static var live: Self {
		.init(
			backgroundQueue: DispatchQueue(label: "background-queue").eraseToAnyScheduler(),
			keychainClient: .live(),
			mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
			passwordValidator: .live,
			userDefaults: .live(),
			walletGenerator: walletGenerator(),
			walletRestorer: walletRestorer()
		)
	}
	
	static func walletGenerator() -> WalletGenerator {
#if DEBUG
		return WalletGenerator.unsafeFast()
#else
		return WalletGenerator.live()
#endif
	}
	
	static func walletRestorer() -> WalletRestorer {
#if DEBUG
		return WalletRestorer.unsafeFast()
#else
		return WalletRestorer.live()
#endif
	}
}
