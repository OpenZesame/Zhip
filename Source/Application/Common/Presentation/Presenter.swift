//
//  Presenter.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol Presenter {
    func present(_ presentable: Presentable, presentation: PresentationMode)
}

extension UINavigationController: Presenter {
    func present(_ presentable: Presentable, presentation: PresentationMode = .animatedPush) {
        let controller = presentable.concrete
        switch presentation {
        case .push(let animated): self.pushViewController(controller, animated: animated)
        }
    }
}
