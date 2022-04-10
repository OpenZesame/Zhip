//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import IdentifiedCollections
import KeychainClient
import PIN
import Purger
import SwiftUI
import Screen
import Styleguide
import TermsOfServiceFeature
import UserDefaultsClient
import VersionFeature
import Wallet

public enum Settings {}

public extension Settings {
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public var isAskingForDeleteWalletConfirmation: Bool
		public var isTermsOfServicePresented = false
		public var version: String?
		
		public var termsOfService: TermsOfService.State
		public var sections: IdentifiedArrayOf<Section>
		
		public init(
			isPINSet: Bool = false,
			isAskingForDeleteWalletConfirmation: Bool = false,
			termsOfService: TermsOfService.State = .init(mode: .userInitiatedFromSettings)
		) {
			self.sections = makeSettingsChoicesSections(isPINSet: isPINSet)
			self.isAskingForDeleteWalletConfirmation = isAskingForDeleteWalletConfirmation
			self.termsOfService = termsOfService
		}
	}
}

public extension Settings {
	enum Action: Equatable {
		case alertDismissed
		case userConfirmedDeletingWallet
		case row(Row.Action)
		case delegate(Delegate)
		
		case onAppear
		case loadPIN
		case pinResponse(Result<PIN?, KeychainClient.Error>)
		
		case termsOfServiceDismissed
		case termsOfService(TermsOfService.Action)
		
	}
}
public extension Settings.Action {
	enum Delegate: Equatable {
		case userDeletedWallet
	}
}

public extension Settings {
	
	struct Environment {
		public var userDefaults: UserDefaultsClient
		public var keychainClient: KeychainClient
		public var mainQueue: AnySchedulerOf<DispatchQueue>
		public var version: () -> Version
		public var purger: Purger
		
		public init(
			userDefaults: UserDefaultsClient,
			keychainClient: KeychainClient,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			purger: Purger? = nil,
			version: @escaping (() -> Version) = Version.fromBundle
		) {
			self.userDefaults = userDefaults
			self.keychainClient = keychainClient
			self.mainQueue = mainQueue
			self.purger = purger ?? Purger.init(userDefaultsClient: userDefaults, keychainClient: keychainClient)
			self.version = version
		}
		
	}
}

public extension Settings {
	static let reducer = Reducer<State, Action, Environment>.combine(
		TermsOfService.reducer.pullback(state: \.termsOfService, action: /Settings.Action.termsOfService, environment: {
			TermsOfService.Environment(userDefaults: $0.userDefaults)
			
		})
		,
		Reducer { state, action, environment in
			switch action {
			case .termsOfService(.delegate(.didAcceptTermsOfService)):
				assertionFailure("Should not be able to presss accept button.")
				return Effect(value: .termsOfServiceDismissed)
			case .termsOfService(.delegate(.done)):
				return Effect(value: .termsOfServiceDismissed)
			case .termsOfService(_):
				return .none
			case .alertDismissed:
				state.alert = nil
				return .none
			case .onAppear:
				let version = environment.version()
				state.version = "App version: \(version.version) (build: \(version.build))"
				return Effect(value: .loadPIN)
			case .loadPIN:
				return environment
					.keychainClient
					.loadPIN()
					.catchToEffect(Settings.Action.pinResponse)
			case let .pinResponse(.success(maybePIN)):
				state.sections = makeSettingsChoicesSections(isPINSet: maybePIN != nil)
				return .none
			case let .pinResponse(.failure(error)):
				fatalError("Failed to load PIN, bad!")
				
				
			case .row(.setPincode):
				state.alert = .init(title: TextState("setPincode pressed"))
				return .none
				
			case .row(.removePincode):
				state.alert = .init(title: TextState("removePincode pressed"))
				return .none
				
			case .row(.starUsOnGithub):
				state.alert = .init(title: TextState("starUsOnGithub pressed"))
				return .none
				
			case .row(.reportIssueOnGithub):
				state.alert = .init(title: TextState("reportIssueOnGithub pressed"))
				return .none
				
			case .row(.acknowledgments):
				state.alert = .init(title: TextState("Acknowledgment pressed"))
				return .none
				
			case .row(.readTermsOfService):
				state.isTermsOfServicePresented = true
				return .none
				
			case .row(.backupWallet):
				state.alert = .init(title: TextState("backupWallet pressed"))
				return .none
				
			case .termsOfServiceDismissed:
				state.isTermsOfServicePresented = false
				return .none
				
			case .row(.removeWallet):
				state.alert = .init(
					title: TextState("Delete Wallet?"),
					message: TextState("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
					buttons: [
						.destructive(
							TextState("Delete Wallet"),
							action: .send(Settings.Action.userConfirmedDeletingWallet)
						)
					]
				)
				return .none
				
				
#if DEBUG
			case .row(.debugOnlyPurgeApp):
				return Effect.merge(
					environment.purger.purge(
						.init(
							keepHasAppRunBeforeFlag: false,
							keepHasAcceptedTermsOfService: false
						)
					).fireAndForget(),
					Effect(value: .delegate(.userDeletedWallet))
				)
				
#endif // DEBUG
				
			case.userConfirmedDeletingWallet:
				return Effect(value: .delegate(.userDeletedWallet))
				
			case .delegate(_):
				return .none
			}
		}
	)
}

public extension Settings {
	struct Screen: View {
		
//		@Environment(\.openURL) var openURL
		
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

private extension Settings.Screen {
	
	struct ViewState: Equatable {
		var sections: IdentifiedArrayOf<Section>
		var isTermsOfServicePresented: Bool
		var version: String?
		init(state: Settings.State) {
			self.sections = state.sections
			self.isTermsOfServicePresented = state.isTermsOfServicePresented
			self.version = state.version
		}
	}
}

public extension Settings.Screen {
	var body: some View {
		WithViewStore(store.scope(state: ViewState.init)) { viewStore in
			ForceFullScreen {
				VStack {
					// Why not use List?
					// Well as of 2022-02-28 we cannot really customize the appearance of
					// a List, especially background color, not the row views
					// (`UITableViewCell`). But everything just works using a `LazyVStack`
					// inside a `ScrollView`.
					ScrollView {
						LazyVStack(alignment: .leading) {
							ForEach(viewStore.sections) { section in
								
								// To be replaced with `Section` in `List` when we can customize
								// the background color of List **and** Section.
								Color.clear.frame(width: 10, height: 10, alignment: .center)
								
								ForEach(section.rows) { row in
									SettingsRowView(row: row) {
										viewStore.send(.row(row.action))
									}
								}
								
							}
						}
					}
					
					if let version = viewStore.version {
						Text(version)
							.font(.footnote)
							.foregroundColor(.silverGrey)
					}
				}
				
			}
			.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
			.sheet(
				isPresented: viewStore.binding(
					get: \.isTermsOfServicePresented,
					send: .termsOfServiceDismissed
				)
			) {
				NavigationView {
					TermsOfService.Screen(
						store: store.scope(
							state: \.termsOfService,
							action: Settings.Action.termsOfService
						)
					)
#if os(iOS)
						.navigationBarTitleDisplayMode(.inline)
#endif
				}
				
			}
			.onAppear { viewStore.send(.onAppear) }
			.navigationTitle("Settings")
		}
	}
}

