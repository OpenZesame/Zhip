//
//  Coordinating+Stack.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension Coordinating {

    func firstIndexOf(child: Coordinating) -> Int? {
        return childCoordinators.firstIndex(where: { $0 === child })
    }

    func remove(childCoordinator child: Coordinating) {
        guard let index = firstIndexOf(child: child) else {
            incorrectImplementation("Should and must be able to find child coordinator and remove it in order to avoid memory leaks.")
        }
        childCoordinators.remove(at: index)

        guard firstIndexOf(child: child) == nil else {
            incorrectImplementation("Child coordinators should not contain the instance of `\(child)` after it have been removed")
        }
    }

    var topMostCoordinator: Coordinating {
        guard let last = childCoordinators.last else { return self }
        return last.topMostCoordinator
    }

    var topMostScene: AbstractController? {
        if let presentedController = topMostCoordinator.navigationController.presentedViewController {
            if let presentedNavigationController = presentedController as? UINavigationController {
                return presentedNavigationController.topViewController as? AbstractController
            } else {
                return presentedController as? AbstractController
            }
        } else {
            return topMostCoordinator.navigationController.topViewController as? AbstractController
        }
    }
}
