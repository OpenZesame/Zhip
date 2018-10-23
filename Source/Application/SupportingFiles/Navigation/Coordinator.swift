//
//  Navigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol AnyCoordinator: AnyObject {
    func start()
}

protocol Coordinator: AnyCoordinator {
    var childCoordinators: [AnyCoordinator] { set get }
    func start(coordinator: AnyCoordinator, mode: CoordinatorStartMode)
}

enum CoordinatorStartMode {
    case append
    case replace
}

extension Coordinator {

    func start(coordinator: AnyCoordinator, mode: CoordinatorStartMode = .append) {
        coordinator.start()
        switch mode {
        case .append:
            childCoordinators.append(coordinator)
        case .replace:
            childCoordinators = [coordinator]
        }
    }
}
