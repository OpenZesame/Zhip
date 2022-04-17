//
//  ZhipApp.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import AppFeature
import ComposableArchitecture

import KeystoreGenerator
import KeystoreGeneratorLive
import KeystoreRestorer
import KeystoreRestorerLive

import KeystoreToFileWriter
import KeystoreFromFileReader

import KeychainClient
import Styleguide
import SwiftUI

import WalletBuilder
import WalletGenerator
import WalletLoader
import WalletRestorer

import protocol Zesame.ZilliqaService
import class Zesame.DefaultZilliqaService
import ZilliqaAPIEndpoint

typealias App = AppFeature.App
typealias AppProtocol = SwiftUI.App


#if DEBUG
import KeystoreGeneratorFastUnsafe
import KeystoreRestorerFastUnsafe
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
		
		let zilliqaService: ZilliqaService = DefaultZilliqaService.default
		
		let keychainClient: KeychainClient = .live()
		
		let keystoreGenerator = Self.keystoreGenerator(zilliqaService: zilliqaService)
		let keystoreRestorer = Self.keystoreRestorer(zilliqaService: zilliqaService)
		
		let keystoreToFileWriter: KeystoreToFileWriter = .live(keychain: keychainClient)
		let keystorFromFileReader: KeystoreFromFileReader = .live(keychain: keychainClient)
		
		let walletBuilder: WalletBuilder = .live(zilliqaService: zilliqaService)
		
		let walletGenerator: WalletGenerator = .live(
			keystoreGenerator: keystoreGenerator,
			keystoreToFileWriter: keystoreToFileWriter,
			walletBuilder: walletBuilder
		)
		
		let walletRestorer: WalletRestorer = .live(
			keystoreRestorer: keystoreRestorer,
			keystoreToFileWriter: keystoreToFileWriter,
			walletBuilder: walletBuilder
		)
		
		let walletLoader: WalletLoader = .live(reader: keystorFromFileReader, builder: walletBuilder)
		
		
		return Self(
			backgroundQueue: DispatchQueue(label: "background-queue").eraseToAnyScheduler(),
			keychainClient: keychainClient,
			mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
			passwordValidator: .live,
			userDefaults: .live(),
			walletGenerator: walletGenerator,
			walletRestorer: walletRestorer,
			walletLoader: walletLoader
		)
	}
	
	static func keystoreGenerator(zilliqaService: ZilliqaService) -> KeystoreGenerator {
		#if DEBUG
		return KeystoreGenerator.fast︕！Unsafe(zilliqaService: zilliqaService)
		#else
		return KeystoreGenerator.live(zilliqaService: zilliqaService)
		#endif
	}
	
	static func keystoreRestorer(zilliqaService: ZilliqaService) -> KeystoreRestorer {
		#if DEBUG
		return KeystoreRestorer.fast︕！Unsafe(zilliqaService: zilliqaService)
		#else
		return KeystoreRestorer.live(zilliqaService: zilliqaService)
		#endif
	}
	
}
