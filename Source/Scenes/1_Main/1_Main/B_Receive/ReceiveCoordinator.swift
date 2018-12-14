//
//  ReceiveNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

final class ReceiveCoordinator: BaseCoordinator<ReceiveCoordinator.NavigationStep> {
    enum NavigationStep {
        case finish
    }

    private let deepLinkGenerator: DeepLinkGenerator
    private let useCaseProvider: UseCaseProvider
    private let walletUseCase: WalletUseCase

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deepLinkGenerator: DeepLinkGenerator) {
        self.useCaseProvider = useCaseProvider
        self.walletUseCase = useCaseProvider.makeWalletUseCase()
        self.deepLinkGenerator = deepLinkGenerator
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toFirst()
    }
}

// MARK: - Navigate
private extension ReceiveCoordinator {

    func toFirst() {
        guard useCaseProvider.makeOnboardingUseCase().hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        toReceive()
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(useCase: useCaseProvider.makeOnboardingUseCase())

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks: self.toReceive()
            }
        }
    }
    func toReceive() {
        let viewModel = ReceiveViewModel(useCase: walletUseCase)

        push(scene: Receive.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .requestTransaction(let requestedTransaction): self.share(transaction: requestedTransaction)
            case .finish: self.finish()
            }
        }
    }

    func finish() {
        navigator.next(.finish)
    }
}

// MARK: - Share
private extension ReceiveCoordinator {
    func share(transaction: TransactionIntent) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = navigationController.navigationItem.rightBarButtonItem
        navigationController.present(activityVC, animated: true, completion: nil)
    }
}
