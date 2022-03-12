//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-07.
//

import ComposableArchitecture
import OnboardingFeature
import UserDefaultsClient
import Styleguide
import SwiftUI

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


let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
	switch action {
//	case let .onboarding(.delegate(action)):
//	  switch action {
//	  case .getStarted:
//		state.onboarding = nil
//		return .none
//	  }
//
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
	
	@ObservedObject var viewStore: ViewStore<ViewState, AppAction>
	
	#if os(iOS)
	@Environment(\.deviceState) var deviceState
	#endif
	
	public init(store: Store<AppState, AppAction>) {
		self.store = store
		self.viewStore = ViewStore(
			self.store.scope(state: ViewState.init)
		)
	}

}

public extension AppView {
	var body: some View {
		Group {
			if viewStore.isOnboardingPresented {
				IfLetStore(
					store.scope(state: \.onboarding, action: AppAction.onboarding),
					then: OnboardingView.init(store:)
				).zIndex(1)
			} else {
				Text("MAIN VIEW").font(.largeTitle)
					.zIndex(0)
			}
		}
		// .modifier(DeviceStateModifier())
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
