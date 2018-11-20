//
//  UIViewController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIViewController {
    func findTopMostViewController() -> UIViewController {
        var topController = self
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    func findTopMostNavigationController() -> UINavigationController? {
        let topController = findTopMostViewController()
        if let navigationController = topController as? UINavigationController {
            return navigationController
        } else {
            return topController.navigationController
        }
    }
}
