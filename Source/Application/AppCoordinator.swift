//
//  AppCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import Zesame

final class AppCoordinator: BaseCoordinator<AppCoordinator.NavigationStep> {
    enum NavigationStep {}

    private let useCaseProvider: UseCaseProvider
    private let deepLinkHandler: DeepLinkHandler

    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, deepLinkHandler: DeepLinkHandler, useCaseProvider: UseCaseProvider) {
        self.deepLinkHandler = deepLinkHandler
        self.useCaseProvider = useCaseProvider

        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
//        let viewModel = RestoreWalletViewModel(useCase: walletUseCase)
//
//        return push(scene: RestoreWallet.self, viewModel: viewModel) { [unowned self] userIntendsTo in
//            switch userIntendsTo {
//            case .restoreWallet(let wallet): abstract
//            }
//        }
        if walletUseCase.hasConfiguredWallet {
            toMain(lockIfNeeded: true)
        } else {
            toOnboarding()
        }
    }
}

// MARK: - Private
private extension AppCoordinator {

    func toOnboarding() {

        let onboarding = OnboardingCoordinator(
            navigationController: navigationController,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: onboarding, transition: .replace) { [unowned self] userDid in
            switch userDid {
            case .finishOnboarding: self.toMain()
            }
        }
    }

    func toMain(lockIfNeeded lock: Bool = false) {

        let main = MainCoordinator(
            navigationController: navigationController,
            deepLinkGenerator: DeepLinkGenerator(),
            useCaseProvider: useCaseProvider,
            deeplinkedTransaction: deepLinkHandler.navigation.map { $0.asTransaction }.filterNil()
        )

        start(coordinator: main, transition: .replace, didStart: { [unowned self] in
                if lock {
                    self.lockApp()
                }
            }, navigationHandler: { [unowned self] userDid in
                switch userDid {
                case .removeWallet: self.toOnboarding()
                }
        })
    }

    func toUnlockAppWithPincodeIfNeeded() {
        guard pincodeUseCase.hasConfiguredPincode, !isCurrentlyPresentingLockScene else { return }

        let viewModel = UnlockAppWithPincodeViewModel(useCase: pincodeUseCase)

        deepLinkHandler.appIsLockedBufferDeeplinks()

        topMostCoordinator.modallyPresent(
            scene: UnlockAppWithPincode.self,
            viewModel: viewModel
        ) { [unowned self] userDid, dismissScene in
            switch userDid {
            case .unlockApp:
                dismissScene(true, { [unowned self] in
                    self.deepLinkHandler.appIsUnlockedEmitBufferedDeeplinks()
                })
            }
        }
    }
}

// MARK: - Lock app with pincode
extension AppCoordinator {
    func appWillResignActive() {
        lockApp()
    }
}

// MARK: - Private Lock app with pincode
private extension AppCoordinator {
    func lockApp() {
        toUnlockAppWithPincodeIfNeeded()
    }

    var isCurrentlyPresentingLockScene: Bool {
        return topMostScene is UnlockAppWithPincode
    }
}

// MARK: - DeepLink Handler
extension AppCoordinator {

    /// returns: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handleDeepLink(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return deepLinkHandler.handle(url: url, options: options)
    }
}
