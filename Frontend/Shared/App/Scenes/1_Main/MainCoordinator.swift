//
//  MainCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-27.
//

import SwiftUI
import ZhipEngine
import Stinsen
import Combine

// MARK: - MainCoordinatorNavigationStep
// MARK: -
public enum MainCoordinatorNavigationStep {
    case userDeletedWallet
}

// MARK: - MainCoordinator
// MARK: -
public final class MainCoordinator: NavigationCoordinatable {

    public let stack: NavigationStack<MainCoordinator>
    
    @Root var tabsCoordinator = makeTabsCoordinator
    @Root var unlockApp = makeUnlockApp
    
    private let appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>
    private unowned let navigator: Navigator

    private let useCaseProvider: UseCaseProvider
    private lazy var unlockAppWithPINNavigator = UnlockAppWithPINViewModel.Navigator()
    private lazy var tabsCoordinatorNavigator = TabsCoordinator.Navigator()
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>,
        navigator: Navigator,
        useCaseProvider: UseCaseProvider,
        promptUserToUnlockAppIfNeeded: Bool = true
    ) {
        self.appLifeCyclePublisher = appLifeCyclePublisher
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
       
        if promptUserToUnlockAppIfNeeded, useCaseProvider.hasConfiguredPincode {
            self.stack = NavigationStack(initial: \.unlockApp)
        } else {
            self.stack = NavigationStack(initial: \.tabsCoordinator)
        }
       
        subscribeToPublishers()
    }
    
    deinit {
        print("✅ MainCoordinator DEINIT 💣")
    }
}

// MARK: - Public
// MARK: -
public extension MainCoordinator {
    typealias Navigator = NavigationStepper<MainCoordinatorNavigationStep>
}

// MARK: - NavigationCoordinatable
// MARK: -
public extension MainCoordinator {
    
    @ViewBuilder
    func customize(_ view: AnyView) -> some View {
        view
            .onReceive(unlockAppWithPINNavigator) { [unowned self] userDid in
                switch userDid {
                case .cancel: fatalError("Should not be able to cancel unlock.")
                case .enteredCorrectPINCode(let userIntent):
                    precondition(userIntent == .enterToUnlockApp)
                    unlockedApp()
                }
            }
            .onReceive(tabsCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDeletedWallet:
                    navigator.step(.userDeletedWallet)
                }
            }
    }
}

// MARK: - Private
// MARK: -
private extension MainCoordinator {
    
    func subscribeToPublishers() {
        appLifeCyclePublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] newPhase in
                if newPhase == .background {
                    lockApp()
                }
            }.store(in: &cancellables)
    }
    
    func unlockedApp() {
        root(\.tabsCoordinator)
    }
    
    func lockApp() {
        root(\.unlockApp)
    }
}

// MARK: - Factory
// MARK: -
private extension MainCoordinator {
    
    @ViewBuilder
    func makeUnlockApp() -> some View {
        
        let viewModel = UnlockAppWithPINViewModel(
            userIntent: .enterToUnlockApp,
            navigator: unlockAppWithPINNavigator,
            useCase: useCaseProvider.makePINCodeUseCase()
        )
        
        UnlockAppWithPINScreen(viewModel: viewModel)
    }
    
    func makeTabsCoordinator() -> TabsCoordinator {
        TabsCoordinator(
            navigator: tabsCoordinatorNavigator,
            useCaseProvider: useCaseProvider
        )
    }
}
