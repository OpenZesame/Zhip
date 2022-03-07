//
//  TabsCoordinator.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

// MARK: - TabsCoordinatorNavigationStep
// MARK: -
public enum TabsCoordinatorNavigationStep {
    case userDeletedWallet
}

// MARK: - TabsCoordinator
// MARK: -
public final class TabsCoordinator: TabCoordinatable {
    
    @Route(tabItem: makeBalancesTab) var balances = makeBalances
    @Route(tabItem: makeReceiveTab) var receive = makeReceive
    @Route(tabItem: makeTransferTab) var transfer = makeTransfer
    @Route(tabItem: makeContactsTab) var contacts = makeContacts
    @Route(tabItem: makeSettingsTab) var settings = makeSettings
    
    public var child = TabChild(
        startingItems: [
            \TabsCoordinator.balances,
            \TabsCoordinator.receive,
            \TabsCoordinator.transfer,
            \TabsCoordinator.contacts,
            \TabsCoordinator.settings
        ]
    )
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    

    private lazy var settingsCoordinatorNavigator = SettingsCoordinator.Navigator()
    
    public init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        #if os(iOS)
        customizeTabBarItemAppearance()
        #endif
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("✅ TabsCoordinator DEINIT 💣")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
public extension TabsCoordinator {
    
    typealias Navigator = NavigationStepper<TabsCoordinatorNavigationStep>
    
    @ViewBuilder
    func customize(_ view: AnyView) -> some View {
        view
            .onReceive(settingsCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDeletedWallet:
                    print("🎬 TabsCoordinator userDeletedWallet")
                    navigator.step(.userDeletedWallet)
                }
            }
    }
}

// MARK: - Factory
// MARK: -
private extension TabsCoordinator {
    
    @ViewBuilder
    func makeBalancesTab(isActive: Bool) -> some View {
        Tab.balances.label(isActive: isActive)
    }
    
    @ViewBuilder
    func makeReceiveTab(isActive: Bool) -> some View {
        Tab.receive.label(isActive: isActive)
    }
    
    @ViewBuilder
    func makeTransferTab(isActive: Bool) -> some View {
        Tab.transfer.label(isActive: isActive)
    }
    
    @ViewBuilder
    func makeContactsTab(isActive: Bool) -> some View {
        Tab.contacts.label(isActive: isActive)
    }
    
    @ViewBuilder
    func makeSettingsTab(isActive: Bool) -> some View {
        Tab.settings.label(isActive: isActive)
    }
    
    func makeBalances() -> NavigationViewCoordinator<BalancesCoordinator> {
        let balancesCoordinator = BalancesCoordinator(
            balancesUseCase: useCaseProvider.makeBalancesUseCase(),
            walletUseCase: useCaseProvider.makeWalletUseCase()
        )
        return NavigationViewCoordinator(balancesCoordinator)
    }
    
    func makeReceive() -> NavigationViewCoordinator<ReceiveCoordinator> {
        let receiveCoordinator = ReceiveCoordinator(
            walletUseCase: useCaseProvider.makeWalletUseCase()
        )
        
        return NavigationViewCoordinator(receiveCoordinator)
    }
    
    func makeTransfer() -> NavigationViewCoordinator<TransferCoordinator> {
        return NavigationViewCoordinator(TransferCoordinator())
    }
    
    func makeContacts() -> NavigationViewCoordinator<ContactsCoordinator> {
        return NavigationViewCoordinator(ContactsCoordinator())
    }
    
    func makeSettings() -> NavigationViewCoordinator<SettingsCoordinator> {
        let settingsCoordinator = SettingsCoordinator(
            navigator: settingsCoordinatorNavigator,
            useCaseProvider: useCaseProvider
        )
        return NavigationViewCoordinator(settingsCoordinator)
    }

}

// MARK: - Tab
// MARK: -
enum Tab {
    case balances
    case receive
    case transfer
    case contacts
    case settings
}

extension Tab {
    
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
