//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import KeychainClient
import MainFeature
import OnboardingFeature
import PINCode
import SplashFeature
import Styleguide
import SwiftUI
import UserDefaultsClient
import Wallet
import WalletGenerator


public struct AppState: Equatable {
	public var splash: SplashState?
	public var onboarding: OnboardingState?
	public var main: MainState?
	
	public init(
		splash: SplashState = .init(),
		onboarding: OnboardingState? = nil,
		main: MainState? = nil
	) {
		self.splash = splash
		self.onboarding = onboarding
		self.main = main
	}
}

public enum AppAction: Equatable {

	case appDelegate(AppDelegateAction)
	case didChangeScenePhase(ScenePhase)
	
	case splash(SplashAction)
	
	case onboardUser
	case onboarding(OnboardingAction)
	
	case loadPIN(Wallet)
	case pinLoadingResult(Wallet, Result<Pincode?, KeychainClient.Error>)
	case failedToLoadPINStartAppAsIfNoPINSet(wallet: Wallet)

	case startApp(wallet: Wallet, pin: Pincode?)
	
	case main(MainAction)
}

public struct AppEnvironment {
	public var userDefaults: UserDefaultsClient
	public var walletGenerator: WalletGenerator
	public var keychainClient: KeychainClient
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		userDefaults: UserDefaultsClient,
		walletGenerator: WalletGenerator,
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.userDefaults = userDefaults
		self.walletGenerator = walletGenerator
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
	}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	
	splashReducer
		.optional()
		.pullback(
			state: \.splash,
			action: /AppAction.splash,
			environment: {
				SplashEnvironment(keychainClient: $0.keychainClient)
			}
		),
	
	onboardingReducer
		.optional()
		.pullback(
			state: \.onboarding,
			action: /AppAction.onboarding,
			environment: {
				OnboardingEnvironment(
					userDefaults: $0.userDefaults,
					walletGenerator: $0.walletGenerator,
					keychainClient: $0.keychainClient,
					mainQueue: $0.mainQueue
				)
			}
		),
	
	mainReducer
		.optional()
		.pullback(
			state: \.main,
			action: /AppAction.main,
			environment: { _ in
				MainEnvironment()
			}),
	
	appReducerCore
)
.debug()


let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
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
		
	case let .pinLoadingResult(wallet, .success(maybePIN)):
		return Effect(value: .startApp(wallet: wallet, pin: maybePIN))
		
		
	case let .splash(.delegate(.foundWallet(wallet))):
		return Effect(value: .loadPIN(wallet))
		
	case .splash(.delegate(.noWallet)):
		state.splash = nil
		return Effect(value: .onboardUser)
		
	case .onboarding(.delegate(.finishedOnboarding)):
		state.onboarding = nil
	  return .none
		
	case .onboardUser:
		state.onboarding = .init()
		return .none
		
	case .didChangeScenePhase(_):
		return .none
		
	case let .startApp(wallet, maybePIN):
		state.splash = nil
		state.main = MainState(wallet: wallet, maybePIN: maybePIN)
		return .none
		
	case .onboarding(_):
		return .none
	case .splash(_):
		return .none
	}
}

public struct AppView: View {
	let store: Store<AppState, AppAction>
	
	#if os(iOS)
	@Environment(\.deviceState) var deviceState
	#endif
	
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
					).zIndex(2)
				} else if viewStore.isOnboardingPresented {
					IfLetStore(
						store.scope(
							state: \.onboarding,
							action: AppAction.onboarding
						),
						then: OnboardingCoordinatorView.init(store:)
					).zIndex(1)
				} else {
					IfLetStore(
						store.scope(
							state: \.main,
							action: AppAction.main
						),
						then: MainCoordinatorView.init(store:)
					).zIndex(0)
				}
			}
			// .modifier(DeviceStateModifier())
		}
	}
}

public extension AppView {
	struct ViewState: Equatable {
		let isSplashPresented: Bool
		let isOnboardingPresented: Bool

		init(state: AppState) {
			self.isSplashPresented = state.splash != nil
			self.isOnboardingPresented = state.onboarding != nil
		}
	}
}
