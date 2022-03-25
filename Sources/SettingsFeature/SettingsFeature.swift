//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import KeychainClient
import PINCode
import SwiftUI
import Screen
import Styleguide
import UserDefaultsClient
import VersionFeature
import Wallet

public extension Row {
	enum Action: Int, Hashable {
		// Section 0
		case removePincode, setPincode
		
		// Section 1
		case starUsOnGithub
		case reportIssueOnGithub
		
		// Section 2
		case acknowledgments
		case readTermsOfService
		//		case readCustomECCWarning
		//		case changeAnalyticsPermissions
		
		// Section 3
		case backupWallet
		case removeWallet
		
#if DEBUG
		// Section 4
		case debugOnlyNukeApp
#endif // DEBUG
	}
}

public struct Section: Equatable, Identifiable {
	public typealias ID = Array<Array<Row>>.Index
	public var id: ID { index }
	let index: ID
	let rows: [Row]
}

public struct Row: Equatable, Identifiable {
	public typealias ID = Action
	public var id: ID { action }
	
	let action: Action
	let title: String
	let icon: Image
	let isDestructive: Bool
	
	init(
		_ action: Action,
		title: String,
		icon: Image,
		isDestructive: Bool = false
	) {
		self.action = action
		self.title = title
		self.icon = icon
		self.isDestructive = isDestructive
	}
	
	init(
		_ action: Action,
		title: String,
		icon: String,
		isDestructive: Bool = false
	) {
		self.init(action, title: title, icon: Image(icon), isDestructive: isDestructive)
	}
	
	init(
		_ action: Action,
		title: String,
		iconSmall: String,
		isDestructive: Bool = false
	) {
		self.init(
			action,
			title: title,
			icon: "Icons/Small/\(iconSmall)",
			isDestructive: isDestructive
		)
	}
}


func makeSettingsChoicesSections(isPINSet: Bool) -> IdentifiedArrayOf<Section> {
	
	let removePINChoice = Row(
		.removePincode,
		title: "Remove pincode",
		iconSmall: "Delete",
		isDestructive: true
	)
	let setPINChoice = Row(
		.setPincode,
		title: "Set pincode",
		iconSmall: "PinCode"
	)
	
	var rowsMatrix: [[Row]] = [
		[
			isPINSet ? removePINChoice : setPINChoice
		],
		[
			.init(
				.starUsOnGithub,
				title: "Star us on Github (login required)",
				iconSmall: "GithubStar"
			),
			.init(
				.reportIssueOnGithub,
				title: "Report issue (Github login required)",
				iconSmall: "GithubIssue"
			),
			.init(
				.acknowledgments,
				title: "Acknowledgments",
				iconSmall: "Cup"
			),
			.init(
				.readTermsOfService,
				title: "Terms of service",
				iconSmall: "Document"
			)
		],
		[
			.init(
				.backupWallet,
				title: "Backup wallet",
				iconSmall: "BackUp"
			),
			.init(
				.removeWallet,
				title: "Remove wallet",
				iconSmall: "Delete",
				isDestructive: true
			)
		]
	]
	
	
#if DEBUG
	rowsMatrix.append(
		[
			Row(
				.debugOnlyNukeApp,
				title: "Nuke app ☣️",
				icon: Image(systemName: "exclamationmark.3"),
				isDestructive: true
			)
		]
	)
#endif // DEBUG
	
	let sections = rowsMatrix.enumerated().map {
		Section(index: $0.offset, rows: $0.element)
	}
	
	return IdentifiedArrayOf(uniqueElements: sections)
}

public struct SettingsState: Equatable {
	public var alert: AlertState<SettingsAction>?
	public var isAskingForDeleteWalletConfirmation: Bool
	public var version: String?
	
	public var sections: IdentifiedArrayOf<Section>
	
	public init(
		isPINSet: Bool = false,
		isAskingForDeleteWalletConfirmation: Bool = false
	) {
		self.sections = makeSettingsChoicesSections(isPINSet: isPINSet)
		self.isAskingForDeleteWalletConfirmation = isAskingForDeleteWalletConfirmation
	}
}

public enum SettingsAction: Equatable {
	case alertDismissed
	case userConfirmedDeletingWallet
	case row(Row.Action)
	case delegate(DelegateAction)
	
	case onAppear
	case loadPIN
	case pinResponse(Result<Pincode?, KeychainClient.Error>)
	
}
public extension SettingsAction {
	enum DelegateAction: Equatable {
		case userDeletedWallet
	}
}

public struct SettingsEnvironment {
	public var userDefaults: UserDefaultsClient
	public var keychainClient: KeychainClient
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	public var version: () -> Version
	
	public init(
		userDefaults: UserDefaultsClient,
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>,
		version: @escaping (() -> Version) = Version.fromBundle
	) {
		self.userDefaults = userDefaults
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
		self.version = version
	}
}

public let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
	switch action {
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
			.catchToEffect(SettingsAction.pinResponse)
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
		state.alert = .init(title: TextState("readTermsOfService pressed"))
		return .none
		
	case .row(.backupWallet):
		state.alert = .init(title: TextState("backupWallet pressed"))
		return .none
		
	case .row(.removeWallet):
		state.alert = .init(
			title: TextState("Delete Wallet?"),
			message: TextState("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
			buttons: [
				.destructive(
					TextState("Delete Wallet"),
					action: .send(SettingsAction.userConfirmedDeletingWallet)
				)
			]
		)
		return .none
		
		
#if DEBUG
	case .row(.debugOnlyNukeApp):
		state.alert = .init(title: .init("debugOnlyNukeApp pressed"))
		return .none
#endif // DEBUG
		
	case.userConfirmedDeletingWallet:
		return Effect(value: .delegate(.userDeletedWallet))
		
	case .delegate(_):
		return .none
	}
}

public struct SettingsView: View {
	
	@Environment(\.openURL) var openURL
	
	let store: Store<SettingsState, SettingsAction>
	public init(
		store: Store<SettingsState, SettingsAction>
	) {
		self.store = store
		//#if os(iOS)
		//		UITableView.appearance().backgroundColor = .clear
		//		UITableViewHeaderFooterView.appearance().backgroundView = .init()
		//#endif
	}
}

public extension SettingsView {
	var body: some View {
		WithViewStore(store) { viewStore in
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
			.onAppear { viewStore.send(.onAppear) }
			.navigationTitle("Settings")
		}
	}
}
