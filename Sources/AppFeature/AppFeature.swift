//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import Common
import ComposableArchitecture
import KeychainClient
import MainFeature
import OnboardingFeature
import PasswordValidator
import PINCode
import SplashFeature
import Styleguide
import SwiftUI
import UserDefaultsClient
import Wallet
import WalletGenerator
import WalletRestorer

public struct AppState: Equatable {
	
	public var isObfuscateAppOverlayPresented: Bool
	
	public var alert: AlertState<AppAction>?
	public var splash: SplashState?
	public var onboarding: Onboarding.State?
	public var main: MainState?
	
	public init(
		isObfuscateAppOverlayPresented: Bool = false,
		splash: SplashState = .init(),
		onboarding: Onboarding.State? = nil,
		main: MainState? = nil
	) {
		self.isObfuscateAppOverlayPresented = isObfuscateAppOverlayPresented
		self.splash = splash
		self.onboarding = onboarding
		self.main = main
	}
}

public enum AppAction: Equatable {

	case appDelegate(AppDelegateAction)
	case didChangeScenePhase(ScenePhase)
	
	case alertDismissed
	
	case splash(SplashAction)
	
	case onboardUser
	case onboarding(Onboarding.Action)
	
	case loadPIN(Wallet)
	case pinLoadingResult(Wallet, Result<Pincode?, KeychainClient.Error>)
	case failedToLoadPINStartAppAsIfNoPINSet(wallet: Wallet)

	case startApp(wallet: Wallet, pin: Pincode?, promptUserToUnlockAppIfNeeded: Bool = true)
	
	case main(MainAction)
	
	case coverAppWithObfuscationOverlay
	case uncoverAppFromObfuscationOverlay
	
	case deleteWalletResult(Result<VoidEq, KeychainClient.Error>)
}

public struct AppEnvironment {
	
	public let backgroundQueue: AnySchedulerOf<DispatchQueue>
	public var keychainClient: KeychainClient
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	public var passwordValidator: PasswordValidator
	public var userDefaults: UserDefaultsClient
	public var walletGenerator: WalletGenerator
	public var walletRestorer: WalletRestorer
	
	public init(
		backgroundQueue: AnySchedulerOf<DispatchQueue>,
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>,
		passwordValidator: PasswordValidator,
		userDefaults: UserDefaultsClient,
		walletGenerator: WalletGenerator,
		walletRestorer: WalletRestorer
	) {
		self.backgroundQueue = backgroundQueue
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
		self.passwordValidator = passwordValidator
		self.userDefaults = userDefaults
		self.walletGenerator = walletGenerator
		self.walletRestorer = walletRestorer
	}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	
	splashReducer
		.optional()
		.pullback(
			state: \.splash,
			action: /AppAction.splash,
			environment: {
				SplashEnvironment(
					keychainClient: $0.keychainClient,
					userDefaultsClient: $0.userDefaults
				)
			}
		),
	
	Onboarding.reducer
		.optional()
		.pullback(
			state: \.onboarding,
			action: /AppAction.onboarding,
			environment: {
				Onboarding.Environment(
					backgroundQueue: $0.backgroundQueue,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue,
					passwordValidator: $0.passwordValidator,
					userDefaults: $0.userDefaults,
					walletGenerator: $0.walletGenerator,
					walletRestorer: $0.walletRestorer
				)
			}
		),
	
	mainReducer
		.optional()
		.pullback(
			state: \.main,
			action: /AppAction.main,
			environment: {
				MainEnvironment(
					userDefaults: $0.userDefaults,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue
				)
			}
		),
	
	appReducerCore
)
.debug()


let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
	let splashMinShowDuration: DispatchQueue.SchedulerTimeType.Stride = 0.7
	switch action {
	case let .appDelegate(appDelegateAction):
		return .none
	
	case let .loadPIN(wallet):
		return environment.keychainClient.loadPIN().catchToEffect {
			AppAction.pinLoadingResult(wallet, $0)
		}
		
	case let .pinLoadingResult(wallet, .failure(error)):
		return Effect(value: .failedToLoadPINStartAppAsIfNoPINSet(wallet: wallet))
		
	case let .failedToLoadPINStartAppAsIfNoPINSet(wallet):
		return Effect(value: .startApp(wallet: wallet, pin: nil))
			.delay(for: splashMinShowDuration, scheduler: environment.mainQueue)
			.eraseToEffect()
		
	case let .pinLoadingResult(wallet, .success(maybePIN)):
		return Effect(value: .startApp(wallet: wallet, pin: maybePIN))
			.delay(for: splashMinShowDuration, scheduler: environment.mainQueue)
			.eraseToEffect()
		
	
		
	case let .splash(.delegate(.foundWallet(wallet))):
		return Effect(value: .loadPIN(wallet))
		
	case .splash(.delegate(.noWallet)):
		state.splash = nil
		return Effect(value: .onboardUser)
		
	case let .onboarding(.delegate(.finished(wallet, pin))):
		state.onboarding = nil
		return Effect(value: .startApp(wallet: wallet, pin: pin, promptUserToUnlockAppIfNeeded: false))
	
	case .onboardUser:
		state.onboarding = .init()
		return .none
		
	case let .didChangeScenePhase(scenePhase):
		// Only care about obfuscating app if we have a wallet setup.
		guard state.main != nil else { return .none }
		
		if scenePhase == .inactive || scenePhase == .background && !state.isObfuscateAppOverlayPresented {
			return Effect(value: .coverAppWithObfuscationOverlay)
		} else if state.isObfuscateAppOverlayPresented && scenePhase == .active {
			return Effect(value: .uncoverAppFromObfuscationOverlay)
		}
		return .none
		
	case .uncoverAppFromObfuscationOverlay:
		state.isObfuscateAppOverlayPresented = false
		return .none
	case .coverAppWithObfuscationOverlay:
		state.isObfuscateAppOverlayPresented = true
		return .none
		
	case let .startApp(wallet, maybePIN, promptUserToUnlockAppIfNeeded):
		state.splash = nil
		state.main = MainState(wallet: wallet, maybePIN: maybePIN, promptUserToUnlockAppIfNeeded: promptUserToUnlockAppIfNeeded)
		return .none
		
	case .main(.delegate(.userDeletedWallet)):
		return environment.keychainClient
			.removeWallet()
			.catchToEffect(AppAction.deleteWalletResult)
		
	case .deleteWalletResult(.success):
		return Effect(value: .onboardUser)
		
	case let .deleteWalletResult(.failure(error)):
		assertionFailure("Failed to delete wallet from keychain.")
		state.alert = .init(
			title: TextState("Delete wallet failed."),
			message: TextState("Failed to delete wallet from keychain. This probably means that there is a bug in Zhip or the keychain wrapper software it uses. ")
		)
		return .none
	case .alertDismissed:
		state.alert = nil
		return .none
		
	case .main(_):
		return .none
	case .onboarding(_):
		return .none
	case .splash(_):
		return .none
	}
}

public struct AppView: View {
	let store: Store<AppState, AppAction>
	
	@Environment(\.scenePhase) private var scenePhase
	
	public init(store: Store<AppState, AppAction>) {
		self.store = store
	}

}

public extension AppView {
	var body: some View {
		WithViewStore(store.scope(state: ViewState.init)) { viewStore in
			Group {
				if viewStore.isSplashPresented {
					IfLetStore(
						store.scope(
							state: \.splash,
							action: AppAction.splash
						),
						then: SplashView.init(store:)
					)
					.zIndex(3)
				} else if viewStore.isOnboardingPresented {
					IfLetStore(
						store.scope(
							state: \.onboarding,
							action: AppAction.onboarding
						),
						then: Onboarding.CoordinatorScreen.init(store:)
					)
					.zIndex(2)
				} else if viewStore.isObfuscateAppOverlayPresented {
					ZhipAuroraView()
						.zIndex(1)
				} else {
					IfLetStore(
						store.scope(
							state: \.main,
							action: AppAction.main
						),
						then: MainCoordinatorView.init(store:)
					)
					.zIndex(0)
				}
			}
		}
	}
}

public extension AppView {
	struct ViewState: Equatable {
		let isObfuscateAppOverlayPresented: Bool
		let isSplashPresented: Bool
		let isOnboardingPresented: Bool

		init(state: AppState) {
			self.isSplashPresented = state.splash != nil
			self.isOnboardingPresented = state.onboarding != nil
			self.isObfuscateAppOverlayPresented = state.isObfuscateAppOverlayPresented
		}
	}
}
