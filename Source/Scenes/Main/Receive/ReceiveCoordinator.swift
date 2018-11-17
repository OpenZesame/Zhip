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

final class ReceiveCoordinator: BaseCoordinator<ReceiveCoordinator.Step> {
    enum Step {
        case finish
    }

    private let deepLinkGenerator: DeepLinkGenerator
    private let useCase: WalletUseCase

    init(presenter: Presenter?, useCase: WalletUseCase, deepLinkGenerator: DeepLinkGenerator) {
        self.useCase = useCase
        self.deepLinkGenerator = deepLinkGenerator
        super.init(presenter: presenter)
        toReceive()
    }

   override func start() {}
}

// MARK: - Navigate
private extension ReceiveCoordinator {

    func toReceive() {
        present(type: Receive.self, viewModel: ReceiveViewModel(useCase: useCase)) { [unowned self] userDid in
            switch userDid {
            case .requestTransaction(let requestedTransaction): self.share(transaction: requestedTransaction)
            case .finish: self.finish()
            }
        }
    }

    func finish() {
        stepper.step(.finish)
    }
}

// MARK: - Share
private extension ReceiveCoordinator {
    func share(transaction: Transaction) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = (presenter as? UINavigationController)?.navigationItem.rightBarButtonItem
        presenter?.present(activityVC, presentation: .animatedPresent)
    }
}
