//
//  SendNavigator.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendNavigator
final class SendCoordinator {

    private weak var navigationController: UINavigationController?
    private let wallet: Wallet

    init(navigationController: UINavigationController, wallet: Wallet) {
        self.navigationController = navigationController
        self.wallet = wallet
    }
}

extension SendCoordinator: AnyCoordinator {
    func start() {
        toSend()
    }
}

protocol SendNavigator: AnyObject {
    func toSend()
}

extension SendCoordinator: SendNavigator {

    func toSend() {
        navigationController?.pushViewController(
            Send(
                viewModel: SendViewModel(navigator: self, wallet: wallet, service: DefaultZilliqaService.shared.rx)
            ),
            animated: true
        )
    }
}
