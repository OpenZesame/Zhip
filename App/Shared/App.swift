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

import enum Zesame.KDF
import struct Zesame.KDFParams

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

var kdfParamsConditional: KDFParams {
#if DEBUG
	return .unsafeFast
#else
	return .default
#endif
}

var kdfConditional: KDF {
#if DEBUG
	return .pbkdf2
#else
	return .scrypt
#endif
}

extension AppEnvironment {
	static var live: Self {
		.init(
			kdf: kdfConditional,
			kdfParams: kdfParamsConditional,
			keychainClient: .live(),
			mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
			passwordValidator: .live,
			userDefaults: .live(),
			walletGenerator: walletGenerator()
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
