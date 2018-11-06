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

final class ReceiveCoordinator: AbstractCoordinator<ReceiveCoordinator.Step> {
    enum Step {}

    private let wallet: Driver<Wallet>
    private let deepLinkGenerator: DeepLinkGenerator

    init(navigationController: UINavigationController, wallet: Driver<Wallet>, deepLinkGenerator: DeepLinkGenerator) {
        self.wallet = wallet
        self.deepLinkGenerator = deepLinkGenerator
        super.init(presenter: navigationController)
    }

   override func start() {
        toReceive()
    }
}
private extension ReceiveCoordinator {
    func share(transaction: Transaction) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = (presenter as? UINavigationController)?.navigationItem.rightBarButtonItem
        presenter?.present(activityVC, presentation: PresentationMode.present(animated: true))
    }
}

private extension ReceiveCoordinator {

    func toReceive() {
        present(type: Receive.self, viewModel: ReceiveViewModel(wallet: wallet)) { [unowned self] in
            switch $0 {
            case .userWouldLikeToReceive(let transactionToReceive): self.share(transaction: transactionToReceive)
            }
        }
    }
}
