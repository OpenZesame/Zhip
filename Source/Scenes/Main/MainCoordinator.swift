//
//  MainNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame
import RxCocoa
import RxSwift

final class MainCoordinator: AbstractCoordinator<MainCoordinator.Step> {
    enum Step {
        case didRemoveWallet
    }

    private let tabBarController: UITabBarController

    private let useCaseProvider: UseCaseProvider
    private let deepLinkGenerator: DeepLinkGenerator

    init(tabBarController: UITabBarController, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        self.tabBarController = tabBarController
        super.init(presenter: nil)
        setupTabBar()
    }

    override func start() {
        focusSendTab()
    }
}

// MARK: - Private
private extension MainCoordinator {
    func setupTabBar() {
        let sendNavigationController = UINavigationController(tabBarTitle: "Send")
        let receiveNavigationController = UINavigationController(tabBarTitle: "Receive")
        let settingsNavigationController = UINavigationController(tabBarTitle: "Settings")

        tabBarController.viewControllers = [
            sendNavigationController,
            receiveNavigationController,
            settingsNavigationController
        ]

        let send = SendCoordinator(
            presenter: sendNavigationController,
            useCaseProvider: useCaseProvider
        )

        let receive = ReceiveCoordinator(
            presenter: receiveNavigationController,
            useCase: useCaseProvider.makeWalletUseCase(),
            deepLinkGenerator: deepLinkGenerator
        )

        let settings = SettingsCoordinator(
            presenter: settingsNavigationController,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: send, transition: .doNothing) {
            switch $0 {} // nothing to do yet
        }

        start(coordinator: receive, transition: .doNothing) {
            switch $0 {}
        }

        start(coordinator: settings, transition: .doNothing) { [unowned stepper] in
            switch $0 {
            case .walletWasRemovedByUser: stepper.step(.didRemoveWallet)
            }
        }

        childCoordinators = [send, receive, settings]
    }

    private func focusSendTab() {
        tabBarController.selectedIndex = 0
    }
}

// MARK: - Deep Link Navigation
extension MainCoordinator {

    func toSend(prefilTransaction transaction: Transaction) {
        guard let sendCoordinator = anyCoordinatorOf(type: SendCoordinator.self) else { return }
        focusSendTab()
        sendCoordinator.toSend(prefilTransaction: transaction)
    }
}
