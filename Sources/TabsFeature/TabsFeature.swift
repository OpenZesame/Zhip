//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-22.
//

import BalancesFeature
import ComposableArchitecture
import ContactsFeature
import KeychainClient
import ReceiveFeature
import SettingsFeature
import SwiftUI
import Styleguide
import TransferFeature
import UserDefaultsClient
import Wallet

public struct TabsState: Equatable {
	
	public var selectedTab: Tab
	
	public var balances: BalancesState
	public var contacts: ContactsState
	public var transfer: TransferState
	public var receive: ReceiveState
	public var settings: SettingsState
	
	public init(wallet: Wallet, isPINSet: Bool = false, selectedTab: Tab = .balances) {
		self.selectedTab = selectedTab
		
		self.balances = .init(wallet: wallet)
		self.contacts = .init()
		self.transfer = .init(wallet: wallet)
		self.receive = .init(wallet: wallet)
		self.settings = .init(isPINSet: isPINSet)
	}
	
}
public enum TabsAction: Equatable {
	
	case selectedTab(Tab)
	
	case balances(BalancesAction)
	case contacts(ContactsAction)
	case transfer(TransferAction)
	case receive(ReceiveAction)
	case settings(SettingsAction)
	
	case delegate(DelegateAction)
}
public extension TabsAction {
	enum DelegateAction: Equatable {
		case userDeletedWallet
	}
}
public struct TabsEnvironment {
	public var userDefaults: UserDefaultsClient
	public var keychainClient: KeychainClient
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		userDefaults: UserDefaultsClient,
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.userDefaults = userDefaults
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
	}
}


public let tabsReducer = Reducer<TabsState, TabsAction, TabsEnvironment>.combine(

	balancesReducer.pullback(
		state: \.balances,
		action: /TabsAction.balances,
		environment: {
			BalancesEnvironment(mainQueue: $0.mainQueue)
		}
	),
	
	contactsReducer.pullback(
		state: \.contacts,
		action: /TabsAction.contacts,
		environment: {
			ContactsEnvironment(mainQueue: $0.mainQueue)
		}
	),
	
	receiveReducer.pullback(
		state: \.receive,
		action: /TabsAction.receive,
		environment: {
			ReceiveEnvironment(mainQueue: $0.mainQueue)
		}
	),
	
	transferReducer.pullback(
		state: \.transfer,
		action: /TabsAction.transfer,
		environment: {
			TransferEnvironment(mainQueue: $0.mainQueue)
		}
	),
	
	settingsReducer.pullback(
		state: \.settings,
		action: /TabsAction.settings,
		environment: {
			SettingsEnvironment(
				userDefaults: $0.userDefaults,
				keychainClient: $0.keychainClient,
				mainQueue: $0.mainQueue
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
			
		case let .selectedTab(selectedTab):
			state.selectedTab = selectedTab
			return .none
			
		case .balances(.delegate(.noop)):
			fatalError()
		case .receive(.delegate(.noop)):
			fatalError()
		case let .transfer(.delegate(.transactionFinalized(txReceipt))):
			fatalError()
		case let .transfer(.delegate(.transactionBroadcastedButSkippedWaitingForFinalization(txID))):
			fatalError()
		case .contacts(.delegate(.noop)):
			fatalError()
			
		case .settings(.delegate(.userDeletedWallet)):
			return Effect(value: .delegate(.userDeletedWallet))
		case .settings(_):
			return .none
			
		case .delegate(_):
			return .none
		}
	}
)

public struct TabsCoordinatorView: View {
	let store: Store<TabsState, TabsAction>
	public init(
		store: Store<TabsState, TabsAction>
	) {
#if os(iOS)
		customizeTabBarItemAppearance()
#endif
		self.store = store
	}
}

public extension TabsCoordinatorView {
	var body: some View {
		WithViewStore(store) { viewStore in
			TabView(selection: viewStore.binding(
				get: \.selectedTab,
				send: TabsAction.selectedTab)
			) {
				NavigationView {
					BalancesView(
						store: store.scope(
							state: \.balances,
							action: TabsAction.balances
						)
					)
#if os(iOS)
					.navigationBarTitleDisplayMode(.inline)
#endif
				}
				.tabItem {
					Tab.balances.label { viewStore.selectedTab == $0 }
				}
				.tag(Tab.balances)
				
				NavigationView {
					ReceiveView(
						store: store.scope(
							state: \.receive,
							action: TabsAction.receive
						)
					)
#if os(iOS)
					.navigationBarTitleDisplayMode(.inline)
#endif
				}
				.tabItem {
					Tab.receive.label { viewStore.selectedTab == $0 }
				}
				.tag(Tab.receive)
				
				NavigationView {
					TransferView(
						store: store.scope(
							state: \.transfer,
							action: TabsAction.transfer
						)
					)
#if os(iOS)
					.navigationBarTitleDisplayMode(.inline)
#endif
				}
				.tabItem {
					Tab.transfer.label { viewStore.selectedTab == $0 }
				}
				.tag(Tab.transfer)
				
				NavigationView {
					ContactsView(
						store: store.scope(
							state: \.contacts,
							action: TabsAction.contacts
						)
					)
#if os(iOS)
					.navigationBarTitleDisplayMode(.inline)
#endif
				}
				.tabItem {
					Tab.contacts.label { viewStore.selectedTab == $0 }
				}
				.tag(Tab.contacts)
				
				NavigationView {
					SettingsView(
						store: store.scope(
							state: \.settings,
							action: TabsAction.settings
						)
					)
#if os(iOS)
					.navigationBarTitleDisplayMode(.inline)
#endif
				}
				.tabItem {
					Tab.settings.label { viewStore.selectedTab == $0 }
				}
				.tag(Tab.settings)
			}
		}
		#if os(iOS)
		.navigationViewStyle(.stack)
		#endif
	}
}

#if os(iOS)
func customizeTabBarItemAppearance() {

    let normalFont = Font.Zhip.iOS.tabNormal
    let selectedFont = Font.Zhip.iOS.tabSelected

    let backgroundColor: Color = .dusk
    let normalColor: Color = .silverGrey
    let selectedColor: Color = .turquoise

    let itemAppearance = UITabBarItemAppearance()

    let backgroundUIColor = UIColor(backgroundColor)
    let normalUIColor = UIColor(normalColor)
    let selectedUIColor = UIColor(selectedColor)

    let titleTextAttributesNormal: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: normalUIColor,
        NSAttributedString.Key.font: normalFont
    ]
    let titleTextAttributesSelected: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: selectedUIColor,
        NSAttributedString.Key.font: selectedFont
    ]
    itemAppearance.normal.iconColor = normalUIColor
    itemAppearance.normal.titleTextAttributes = titleTextAttributesNormal

    itemAppearance.selected.iconColor = selectedUIColor
    itemAppearance.selected.titleTextAttributes = titleTextAttributesSelected

    let appeareance = UITabBarAppearance()

    appeareance.backgroundColor = backgroundUIColor
    appeareance.stackedLayoutAppearance = itemAppearance
    appeareance.inlineLayoutAppearance = itemAppearance
    appeareance.compactInlineLayoutAppearance = itemAppearance

    UITabBar.appearance().standardAppearance = appeareance
    UITabBar.appearance().scrollEdgeAppearance = appeareance
}
#endif


// MARK: - Tab
// MARK: -
public enum Tab: String, Hashable {
	case balances
	case receive
	case transfer
	case contacts
	case settings
}

public extension Tab {
	
	var name: String {
		switch self {
		case .balances: return "Balances"
		case .receive: return "Receive"
		case .transfer: return "Transfer"
		case .contacts: return "Contacts"
		case .settings: return "Settings"
		}
	}
	
	var imageName: String {
		switch self {
		case .balances: return "bitcoinsign.circle"
		case .receive: return "arrow.down.circle"
		case .transfer: return "arrow.up.circle"
		case .contacts: return "heart"
		case .settings: return "gear"
		}
	}
	
	@ViewBuilder
	func label(
		isActive checkIfActive: (Tab) -> Bool
	) -> some View {
		let _ = checkIfActive(self) // can use this to further customize tab if active
		Label(name, systemImage: imageName)
	}
	
}



