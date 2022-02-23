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

final class BalancesCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<BalancesCoordinator>(initial: \.start)
    @Root var start = makeStart
    let wallet: Wallet
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    
    @ViewBuilder
    func makeStart() -> some View {
        BalancesScreen(wallet: wallet)
    }
}

final class TransferCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<TransferCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    @ViewBuilder
    func makeStart() -> some View {
        TransferScreen()
    }
}

final class ContactsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<ContactsCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    @ViewBuilder
    func makeStart() -> some View {
        ContactsScreen()
    }
}

final class SettingsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<SettingsCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    @ViewBuilder
    func makeStart() -> some View {
        SettingsScreen()
    }
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
    
    init(navigator: Navigator, wallet: Wallet) {
        self.navigator = navigator
        self.wallet = wallet
    }
    
    deinit {
        print("Deinit MainCoordinator")
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
        return NavigationViewCoordinator(SettingsCoordinator())
    }
}
