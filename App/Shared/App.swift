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
#if DEBUG
import WalletGeneratorUnsafeFast
#endif // DEBUG

private func makeAppStore() -> Store<AppState, AppAction> {
	.init(
		initialState: .init(),
		reducer: appReducer,
		environment: .live
	)
}

private func makeViewStore(from store: Store<AppState, AppAction>) -> ViewStore<Void, AppAction> {
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
struct ZhipApp: App {
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
			AppView(store: store)
				.background(Color.appBackground)
				.foregroundColor(.white)
				.navigationBarTitleDisplayMode(.large)
		}
		.onChange(of: scenePhase) {
			viewStore.send(.didChangeScenePhase($0))
		}
    }
}

extension ZhipApp {
	var store: Store<AppState, AppAction> {
		#if os(iOS)
		appDelegate.store
		#else
		_store
		#endif
	}
	
	var viewStore: ViewStore<Void, AppAction> {
		#if os(iOS)
		appDelegate.viewStore
		#else
		_viewStore
		#endif
	}
	
}

extension AppEnvironment {
	static var live: Self {
		.init(
			userDefaults: .live(),
			walletGenerator: walletGenerator(),
			keychainClient: .live(),
			mainQueue: DispatchQueue.main.eraseToAnyScheduler()
		)
	}
	
	static func walletGenerator() -> WalletGenerator {
#if DEBUG
		return WalletGenerator.unsafeFast()
#else
		return WalletGenerator.live()
#endif
	}
}
