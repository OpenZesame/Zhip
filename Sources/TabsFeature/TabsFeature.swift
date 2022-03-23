//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-22.
//

import ComposableArchitecture
import SwiftUI
import Wallet

public struct TabsState: Equatable {
	public var wallet: Wallet
	public init(wallet: Wallet) {
		self.wallet = wallet
	}
}
public enum TabsAction: Equatable {
	case delegate(DelegateAction)
}
public extension TabsAction {
	enum DelegateAction: Equatable {
		case userDeletedWallet
	}
}
public struct TabsEnvironment {
	public init() {}
}

public let tabsReducer = Reducer<TabsState, TabsAction, TabsEnvironment> { state, action, environment in
	return .none
}

public struct TabsCoordinatorView: View {
	let store: Store<TabsState, TabsAction>
	public init(
		store: Store<TabsState, TabsAction>
	) {
		self.store = store
	}
}

public extension TabsCoordinatorView {
	var body: some View {
		WithViewStore(store) { viewStore in
			Text("TabsCoordinatorView!")
			Text("Wallet address: \(viewStore.wallet.bech32Address.asString)")
		}
	}
}

//#if os(iOS)
//func customizeTabBarItemAppearance() {
//
//    let normalFont = Font.Zhip.iOS.tabNormal
//    let selectedFont = Font.Zhip.iOS.tabSelected
//
//    let backgroundColor: Color = .dusk
//    let normalColor: Color = .silverGrey
//    let selectedColor: Color = .turquoise
//
//    let itemAppearance = UITabBarItemAppearance()
//
//    let backgroundUIColor = UIColor(backgroundColor)
//    let normalUIColor = UIColor(normalColor)
//    let selectedUIColor = UIColor(selectedColor)
//
//    let titleTextAttributesNormal: [NSAttributedString.Key: Any] = [
//        NSAttributedString.Key.foregroundColor: normalUIColor,
//        NSAttributedString.Key.font: normalFont
//    ]
//    let titleTextAttributesSelected: [NSAttributedString.Key: Any] = [
//        NSAttributedString.Key.foregroundColor: selectedUIColor,
//        NSAttributedString.Key.font: selectedFont
//    ]
//    itemAppearance.normal.iconColor = normalUIColor
//    itemAppearance.normal.titleTextAttributes = titleTextAttributesNormal
//
//    itemAppearance.selected.iconColor = selectedUIColor
//    itemAppearance.selected.titleTextAttributes = titleTextAttributesSelected
//
//    let appeareance = UITabBarAppearance()
//
//    appeareance.backgroundColor = backgroundUIColor
//    appeareance.stackedLayoutAppearance = itemAppearance
//    appeareance.inlineLayoutAppearance = itemAppearance
//    appeareance.compactInlineLayoutAppearance = itemAppearance
//
//    UITabBar.appearance().standardAppearance = appeareance
//    UITabBar.appearance().scrollEdgeAppearance = appeareance
//}
//#endif


// MARK: - Tab
// MARK: -
public enum Tab {
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
	func label(isActive: Bool) -> some View {
		Label(name, systemImage: imageName)
	}
	
}



