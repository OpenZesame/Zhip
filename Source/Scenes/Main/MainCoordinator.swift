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

private typealias € = L10n.Scene

final class MainCoordinator: AbstractCoordinator<MainCoordinator.Step> {
    enum Step {
        case didRemoveWallet
    }

    private let tabBarController: UITabBarController

    private let useCaseProvider: UseCaseProvider
    private let deepLinkGenerator: DeepLinkGenerator
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(tabBarController: UITabBarController, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider, lockApp: Driver<Void>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        self.tabBarController = tabBarController
        super.init(presenter: nil)
        setupTabBar()
        bag <~ lockApp.do(onNext: { [unowned self] in
            self.toUnlockAppWithPincodeIfNeeded()
        }).drive()
    }

    override func start() {
        focusSendTab()
    }

    override var presenter: Presenter? {
        return tabBarController.selectedViewController
    }
}

// MARK: - Private
private extension MainCoordinator {
    // swiftlint:disable:next function_body_length
    func setupTabBar() {
        let sendNavigationController = UINavigationController()
        let receiveNavigationController = UINavigationController()
        let settingsNavigationController = UINavigationController()

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

        start(coordinator: settings, transition: .doNothing) { [unowned self] in
            switch $0 {
            case .walletWasRemovedByUser: self.stepper.step(.didRemoveWallet)
            case .userWantsToSetPincode: self.toPincode(intent: .setPincode)
            case .userWantsToRemovePincode: self.toPincode(intent: .unlockApp(toRemovePincode: true))
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

    func toUnlockAppWithPincodeIfNeeded() {
        guard pincodeUseCase.hasConfiguredPincode else { return }
        toPincode(intent: .unlockApp(toRemovePincode: false))
    }

    func toPincode(intent: ManagePincodeCoordinator.Intent) {
        guard let presenter = presenter else {
            incorrectImplementation("Should be able to present pincode")
        }
        let navigationController = UINavigationController()
        let coordinator = ManagePincodeCoordinator(
            intent: intent,
            presenter: navigationController,
            useCase: useCaseProvider.makePincodeUseCase()
        )
        presenter.present(navigationController, presentation: .present(animated: false, completion: nil))
        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .userFinishedChoosingOrRemovingPincode:
                navigationController.dismiss(animated: true)
                self.childCoordinators.removeLast()
            }
        }
    }
}
