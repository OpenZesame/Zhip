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

    private let deepLinkGenerator: DeepLinkGenerator
    private let useCase: WalletUseCase

    init(presenter: Presenter?, useCase: WalletUseCase, deepLinkGenerator: DeepLinkGenerator) {
        self.useCase = useCase
        self.deepLinkGenerator = deepLinkGenerator
        super.init(presenter: presenter)
    }

   override func start() {
        toReceive()
    }
}


// MARK: - Navigate
private extension ReceiveCoordinator {

    func toReceive() {
        present(type: Receive.self, viewModel: ReceiveViewModel(useCase: useCase)) { [unowned self] in
            switch $0 {
            case .userWouldLikeToReceive(let transactionToReceive): self.share(transaction: transactionToReceive)
            }
        }
    }
}

// MARK: - Share
private extension ReceiveCoordinator {
    func share(transaction: Transaction) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = (presenter as? UINavigationController)?.navigationItem.rightBarButtonItem
        presenter?.present(activityVC, presentation: PresentationMode.present(animated: true))
    }
}
