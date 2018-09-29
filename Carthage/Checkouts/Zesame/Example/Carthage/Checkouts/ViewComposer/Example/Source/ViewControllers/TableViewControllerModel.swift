//
//  TableViewControllerModel.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-13.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

struct Model {
    let title: String
    let viewControllerType: UIViewController.Type
    let vanillaViewControllerType: UIViewController.Type?
    init(_ title: String, type: UIViewController.Type, vanilla vanillaType: UIViewController.Type? = nil) {
        self.title = title
        self.viewControllerType = type
        self.vanillaViewControllerType = vanillaType
    }
}

extension Model {
    func push(onto navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        let viewComposerViewController = viewControllerType.init()
        if let vanilla = vanillaViewControllerType {
            let alert = UIAlertController()
            alert.addAction(actionForVanilla(true, viewController: vanilla.init(), navigationController: navigationController))
            alert.addAction(actionForVanilla(false, viewController: viewComposerViewController, navigationController: navigationController))
            navigationController.present(alert, animated: true, completion: nil)
        } else {
            navigationController.pushViewController(viewComposerViewController, animated: true)
        }
    }
    
    
    func actionForVanilla(_ vanilla: Bool, viewController: UIViewController, navigationController: UINavigationController) -> UIAlertAction {
        let title = vanilla ? "Vanilla" : "ViewComposer"
        let action = UIAlertAction(title: title, style: .default) { _ in
            navigationController.pushViewController(viewController, animated: true)
        }
        return action
    }
}
