//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import KeychainClient
import OnboardingFeature
import Styleguide
import SwiftUI
import UserDefaultsClient
import WalletGenerator

public struct AppState: Equatable {
	public var onboarding: OnboardingState?
	
	public init(
		onboarding: OnboardingState = .init()
	) {
		self.onboarding = onboarding
	}
}

public enum AppAction: Equatable {
	
	case appDelegate(AppDelegateAction)
	
	case didChangeScenePhase(ScenePhase)
	
	case onboarding(OnboardingAction)
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
	
	appReducerCore
)
.debug()


let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
	switch action {
	case let .appDelegate(appDelegateAction):
		return .none
	case .onboarding:
	  return .none
	case .didChangeScenePhase(_):
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
				if viewStore.isOnboardingPresented {
					IfLetStore(
						store.scope(state: \.onboarding, action: AppAction.onboarding),
						then: OnboardingCoordinatorView.init(store:)
					).zIndex(1)
				} else {
					Text("MAIN VIEW").font(.largeTitle)
						.zIndex(0)
				}
			}
			// .modifier(DeviceStateModifier())
		}
	}
}

public extension AppView {
	struct ViewState: Equatable {
		let isOnboardingPresented: Bool

		init(state: AppState) {
			self.isOnboardingPresented = state.onboarding != nil
		}
	}
}
