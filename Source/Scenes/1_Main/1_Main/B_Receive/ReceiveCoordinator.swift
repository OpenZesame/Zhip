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
    private let useCase: WalletUseCase

    init(navigationController: UINavigationController, useCase: WalletUseCase, deepLinkGenerator: DeepLinkGenerator) {
        self.useCase = useCase
        self.deepLinkGenerator = deepLinkGenerator
        super.init(navigationController: navigationController)
    }

    override func start(didStart: CoordinatorDidStart? = nil) {
        toReceive()
    }
}

// MARK: - Navigate
private extension ReceiveCoordinator {

    func toReceive() {
        let viewModel = ReceiveViewModel(useCase: useCase)

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
    func share(transaction: Transaction) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = navigationController.navigationItem.rightBarButtonItem
        navigationController.present(activityVC, animated: true, completion: nil)
    }
}
