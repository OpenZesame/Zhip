//
//  Navigator.swift
//  ZesameiOSExample
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
    func start(coordinator: AnyCoordinator)
}

extension Coordinator {
    func start(coordinator: AnyCoordinator) {
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
