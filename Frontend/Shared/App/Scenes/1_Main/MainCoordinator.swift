//
//  MainCoordinator.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

enum MainCoordinatorNavigationStep {
    case userDeletedWallet
}

final class MainCoordinator: TabCoordinatable {
    
    typealias Navigator = NavigationStepper<MainCoordinatorNavigationStep>
    
    let wallet: Wallet
    
    @Route(tabItem: makeBalancesTab) var balances = makeBalances
    @Route(tabItem: makeReceiveTab) var receive = makeReceive
    @Route(tabItem: makeTransferTab) var transfer = makeTransfer
    @Route(tabItem: makeContactsTab) var contacts = makeContacts
    @Route(tabItem: makeSettingsTab) var settings = makeSettings
    
    var child = TabChild(
        startingItems: [
            \MainCoordinator.balances,
            \MainCoordinator.receive,
            \MainCoordinator.transfer,
            \MainCoordinator.contacts,
            \MainCoordinator.settings
        ]
    )
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    
    private lazy var settingsCoordinatorNavigator = SettingsCoordinator.Navigator()
    
    init(navigator: Navigator, useCaseProvider: UseCaseProvider, wallet: Wallet) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
        self.wallet = wallet
    }
    
    deinit {
        print("✅ MainCoordinator DEINIT 💣")
    }
}


// MARK: - NavigationCoordinatable
// MARK: -
extension MainCoordinator {
    
    @ViewBuilder
    func customize(_ view: AnyView) -> some View {
        view
            .onReceive(settingsCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDeletedWallet:
                    print("🎬 MainCoordinator userDeletedWallet")
                    navigator.step(.userDeletedWallet)
                }
            }
       
    }
}

extension MainCoordinator {
    
    @ViewBuilder
    func makeBalancesTab(isActive: Bool) -> some View {
        Tab.balances.label
    }
    
    @ViewBuilder
    func makeReceiveTab(isActive: Bool) -> some View {
        Tab.receive.label
    }
    
    @ViewBuilder
    func makeTransferTab(isActive: Bool) -> some View {
        Tab.transfer.label
    }
    
    @ViewBuilder
    func makeContactsTab(isActive: Bool) -> some View {
        Tab.contacts.label
    }
    
    @ViewBuilder
    func makeSettingsTab(isActive: Bool) -> some View {
        Tab.settings.label
    }
    
    func makeBalances() -> NavigationViewCoordinator<BalancesCoordinator> {
        let balancesCoordinator = BalancesCoordinator(
            balancesUseCase: useCaseProvider.makeBalancesUseCase(),
            walletUseCase: useCaseProvider.makeWalletUseCase()
        )
        return NavigationViewCoordinator(balancesCoordinator)
    }
    
    func makeReceive() -> NavigationViewCoordinator<ReceiveCoordinator> {
        return NavigationViewCoordinator(ReceiveCoordinator(
            walletUseCase: useCaseProvider.makeWalletUseCase()
        ))
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
    var label: some View {
        Label(name, systemImage: imageName)
    }
}

