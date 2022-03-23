////
////  TabsCoordinator.swift
////  Shared
////
////  Created by Alexander Cyon on 2022-02-12.
////
//
//import SwiftUI
//import Stinsen
//import ZhipEngine
//
//// MARK: - TabsCoordinatorNavigationStep
//// MARK: -
//public enum TabsCoordinatorNavigationStep {
//    case userDeletedWallet
//}
//
//// MARK: - TabsCoordinator
//// MARK: -
//public final class TabsCoordinator: TabCoordinatable {
//    
//    @Route(tabItem: makeBalancesTab) var balances = makeBalances
//    @Route(tabItem: makeReceiveTab) var receive = makeReceive
//    @Route(tabItem: makeTransferTab) var transfer = makeTransfer
//    @Route(tabItem: makeContactsTab) var contacts = makeContacts
//    @Route(tabItem: makeSettingsTab) var settings = makeSettings
//
//    public var child = TabChild(
//        startingItems: [
//            \TabsCoordinator.balances,
//            \TabsCoordinator.receive,
//            \TabsCoordinator.transfer,
//            \TabsCoordinator.contacts,
//            \TabsCoordinator.settings
//        ]
//    )
//
//    private unowned let navigator: Navigator
//    private let useCaseProvider: UseCaseProvider
//
//
//    private lazy var settingsCoordinatorNavigator = SettingsCoordinator.Navigator()
//
//    public init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
//        #if os(iOS)
//        customizeTabBarItemAppearance()
//        #endif
//        self.navigator = navigator
//        self.useCaseProvider = useCaseProvider
//    }
//
//    deinit {
//        print("✅ TabsCoordinator DEINIT 💣")
//    }
//}
//
//// MARK: - NavigationCoordinatable
//// MARK: -
//public extension TabsCoordinator {
//
//    typealias Navigator = NavigationStepper<TabsCoordinatorNavigationStep>
//
//    @ViewBuilder
//    func customize(_ view: AnyView) -> some View {
//        view
//            .onReceive(settingsCoordinatorNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .userDeletedWallet:
//                    print("🎬 TabsCoordinator userDeletedWallet")
//                    navigator.step(.userDeletedWallet)
//                }
//            }
//    }
//}
//
//// MARK: - Factory
//// MARK: -
//private extension TabsCoordinator {
//
//    @ViewBuilder
//    func makeBalancesTab(isActive: Bool) -> some View {
//        Tab.balances.label(isActive: isActive)
//    }
//
//    @ViewBuilder
//    func makeReceiveTab(isActive: Bool) -> some View {
//        Tab.receive.label(isActive: isActive)
//    }
//
//    @ViewBuilder
//    func makeTransferTab(isActive: Bool) -> some View {
//        Tab.transfer.label(isActive: isActive)
//    }
//
//    @ViewBuilder
//    func makeContactsTab(isActive: Bool) -> some View {
//        Tab.contacts.label(isActive: isActive)
//    }
//
//    @ViewBuilder
//    func makeSettingsTab(isActive: Bool) -> some View {
//        Tab.settings.label(isActive: isActive)
//    }
//
//    func makeBalances() -> NavigationViewCoordinator<BalancesCoordinator> {
//        let balancesCoordinator = BalancesCoordinator(
//            balancesUseCase: useCaseProvider.makeBalancesUseCase(),
//            walletUseCase: useCaseProvider.makeWalletUseCase()
//        )
//        return NavigationViewCoordinator(balancesCoordinator)
//    }
//
//    func makeReceive() -> NavigationViewCoordinator<ReceiveCoordinator> {
//        let receiveCoordinator = ReceiveCoordinator(
//            walletUseCase: useCaseProvider.makeWalletUseCase()
//        )
//
//        return NavigationViewCoordinator(receiveCoordinator)
//    }
//
//    func makeTransfer() -> NavigationViewCoordinator<TransferCoordinator> {
//        return NavigationViewCoordinator(TransferCoordinator())
//    }
//
//    func makeContacts() -> NavigationViewCoordinator<ContactsCoordinator> {
//        return NavigationViewCoordinator(ContactsCoordinator())
//    }
//
//    func makeSettings() -> NavigationViewCoordinator<SettingsCoordinator> {
//        let settingsCoordinator = SettingsCoordinator(
//            navigator: settingsCoordinatorNavigator,
//            useCaseProvider: useCaseProvider
//        )
//        return NavigationViewCoordinator(settingsCoordinator)
//    }
//
//}
