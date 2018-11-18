//
//  UIViewController+Present.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIViewController {
    func present(viewController: UIViewController, presentation: PresentationMode) {
        if let navigationController = self as? UINavigationController {
            switch presentation {
            case .push(let animated): navigationController.pushViewController(viewController, animated: animated)
            case .present(let animated, let completion): navigationController.present(viewController, animated: animated, completion: completion)
            case .none: navigationController.viewControllers = [viewController]
            }
        } else {
            switch presentation {
            case .push:
                if let navigationController = navigationController {
                    navigationController.present(viewController: viewController, presentation: presentation)
                } else {
                    incorrectImplementation("Unable to push without a navigation controller")
                }
            case .present(let animated, let completion):
                present(viewController, animated: animated, completion: completion)
            case .none: incorrectImplementation("Incorrect use of presentation")
            }
        }
    }
}
