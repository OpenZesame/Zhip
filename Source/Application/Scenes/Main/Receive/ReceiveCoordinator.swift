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

    init(navigationController: UINavigationController, wallet: Driver<Wallet>) {
        self.wallet = wallet
        super.init(presenter: navigationController)
    }

   override func start() {
        toReceive()
    }
}

private extension ReceiveCoordinator {

    func toReceive() {
        present(type: Receive.self, viewModel: ReceiveViewModel(wallet: wallet)) {
            switch $0 {}
        }
    }
}
