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

class AbstractCoordinator<Step>: Coordinator {

    var childCoordinators = [BaseCoordinator]()
    let stepper = Stepper<Step>()
    let bag = DisposeBag()
    let navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    // MARK: - Overridable
    func start() {
        fatalError("override me")
    }
}

extension AbstractCoordinator {
    var navigation: Driver<Step> {
        return stepper.navigationSteps
    }

    var concrete: UIViewController {
        return navigationController
    }
}
