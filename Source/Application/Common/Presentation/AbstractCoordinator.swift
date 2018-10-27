//
//  AbstractCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AbstractCoordinator<NavigationStep>: Coordinator {

    let stepper = Stepper<NavigationStep>()
    var navigation: Driver<NavigationStep> {
        return stepper.navigation
    }

    typealias Step = NavigationStep

    var concrete: UIViewController {
        return navigationController!
    }

    var childCoordinators = [BaseCoordinator]()

    func start() {
        fatalError("override me")
    }

    var navigationController: UINavigationController?

    let bag = DisposeBag()

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
}
