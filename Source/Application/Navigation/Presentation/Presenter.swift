//
//  Presenter.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol Presenter: AnyObject {
    func present(_ presentable: Presentable, presentation: PresentationMode)
    func dismiss(animated: Bool)
}

extension UIViewController: Presenter {
    func present(_ presentable: Presentable, presentation: PresentationMode) {
        let controllerToPresent = presentable.concrete

        if let navigationController = self as? UINavigationController {
            switch presentation {
            case .push(let animated): navigationController.pushViewController(controllerToPresent, animated: animated)
            case .present(let animated): navigationController.present(controllerToPresent, animated: animated, completion: nil)
            }
        } else {
            switch presentation {
            case .push:
                if let navigationController = navigationController {
                    navigationController.present(controllerToPresent, presentation: presentation)
                } else {
                    incorrectImplementation("Unable to push without a navigation controller")
                }
            case .present(let animated):
                present(controllerToPresent, animated: animated, completion: nil)
            }
        }
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}
