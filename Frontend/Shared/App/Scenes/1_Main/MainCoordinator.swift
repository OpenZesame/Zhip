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
    @Route(tabItem: makeTransferTab) var transfer = makeTransfer
    @Route(tabItem: makeContactsTab) var contacts = makeContacts
    @Route(tabItem: makeSettingsTab) var settings = makeSettings
    
    var child = TabChild(
        startingItems: [
            \MainCoordinator.balances,
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
    @ViewBuilder func customize(_ view: AnyView) -> some View {
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
        TopLevelNavigationItem.balances.label
    }
    
    @ViewBuilder
    func makeTransferTab(isActive: Bool) -> some View {
        TopLevelNavigationItem.transfer.label
    }
    
    @ViewBuilder
    func makeContactsTab(isActive: Bool) -> some View {
        TopLevelNavigationItem.contacts.label
    }
    
    @ViewBuilder
    func makeSettingsTab(isActive: Bool) -> some View {
        TopLevelNavigationItem.settings.label
    }
    
    func makeBalances() -> NavigationViewCoordinator<BalancesCoordinator> {
        return NavigationViewCoordinator(BalancesCoordinator(wallet: wallet))
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
