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
}

extension UINavigationController: Presenter {
    func present(_ presentable: Presentable, presentation: PresentationMode = .animatedPush) {
        let controller = presentable.concrete
        switch presentation {
        case .push(let animated): pushViewController(controller, animated: animated)
        case .present(let animated): present(controller, animated: animated, completion: nil)
        }
    }
}
