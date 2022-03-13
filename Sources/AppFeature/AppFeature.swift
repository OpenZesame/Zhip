//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import OnboardingFeature
import Styleguide
import SwiftUI
import UserDefaultsClient

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
	
	public init(
		userDefaults: UserDefaultsClient
	) {
		self.userDefaults = userDefaults
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
					userDefaults: $0.userDefaults
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
