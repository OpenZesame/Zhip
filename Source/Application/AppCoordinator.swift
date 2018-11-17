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

final class AppCoordinator: BaseCoordinator<AppCoordinator.Step> {
    enum Step {}

    private unowned let window: UIWindow
    private let useCaseProvider: UseCaseProvider
    private let deepLinkHandler: DeepLinkHandler

    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private let lockAppSubject = ReplaySubject<Void>.create(bufferSize: 1)

    init(window: UIWindow, deepLinkHandler: DeepLinkHandler, useCaseProvider: UseCaseProvider) {
        self.window = window
        self.deepLinkHandler = deepLinkHandler
        self.useCaseProvider = useCaseProvider
        super.init(presenter: nil)
        setupDeepLinkNavigationHandling()
    }

    override func start() {
        if walletUseCase.hasConfiguredWallet {
            lockApp()
            toMain()
        } else {
            toOnboarding()
        }
    }
}

// MARK: - Private
private extension AppCoordinator {

    func toOnboarding() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        let onboarding = OnboardingCoordinator(
            presenter: navigationController,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: onboarding, transition: .replace) { [unowned self] in
            switch $0 {
            case .userFinishedOnboording: self.toMain()
            }
        }
    }

    func toMain() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        let main = MainCoordinator(
            presenter: navigationController,
            deepLinkGenerator: DeepLinkGenerator(),
            useCaseProvider: useCaseProvider,
            lockApp: lockAppSubject.asDriverOnErrorReturnEmpty()
        )

        start(coordinator: main, transition: .replace) { [unowned self] in
            switch $0 {
            case .didRemoveWallet: self.toOnboarding()
            }
        }
    }
}

// MARK: - App forground/background + Pincode
extension AppCoordinator {
    func appWillEnterForeground() {
        lockApp()
    }

    private func lockApp() {
        lockAppSubject.onNext(())
    }
}

// MARK: - DeepLink Handler
extension AppCoordinator {

    /// returns: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handleDeepLink(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return deepLinkHandler.handle(url: url, options: options)
    }

    func setupDeepLinkNavigationHandling() {
        let deepLinkStepper = Stepper<DeepLink>()
        deepLinkHandler.set(stepper: deepLinkStepper)
        bag <~ deepLinkStepper.navigation.do(onNext: { [unowned self] in
            switch $0 {
            case .send(let transaction): self.toSend(prefilTransaction: transaction)
            }
        }).drive()
    }
}

// MARK: Private DeepLink navigation
private extension AppCoordinator {
    func toSend(prefilTransaction transaction: Transaction) {
        guard let mainCoordinator = anyCoordinatorOf(type: MainCoordinator.self) else { return }
        mainCoordinator.toSendPrefilTransaction(transaction)
    }
}
