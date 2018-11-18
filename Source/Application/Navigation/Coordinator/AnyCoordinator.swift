//
//  AnyCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol AnyCoordinator: AnyObject, CustomStringConvertible {
    var childCoordinators: [AnyCoordinator] { get set }
    func start()
}

extension AnyCoordinator {
    var description: String {
        return "\(type(of: self)), #\(childCoordinators.count) children"
    }
}
