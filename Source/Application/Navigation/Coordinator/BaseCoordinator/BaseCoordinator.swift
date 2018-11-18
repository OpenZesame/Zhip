//
//  BaseCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseCoordinator<Step>: AnyCoordinator, Navigatable {

    var childCoordinators = [AnyCoordinator]()

    let stepper = Stepper<Step>()
    let bag = DisposeBag()
    private(set) var presenter: UINavigationController

    lazy var navigation = stepper.navigation

    // MARK: - Initialization
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    // MARK: - Overridable
    func start() { abstract }

    deinit {
        log.verbose("💣 \(String(describing: self))")
    }
}

// MARK: - Start Child Coordinator
extension BaseCoordinator {

    func start<C>(
        coordinator: C,
        transition: CoordinatorTransition = .append,
        navigationHandler: @escaping (C.Step) -> Void
        ) where C: AnyCoordinator & Navigatable {

        switch transition {
        case .replace: childCoordinators = [coordinator]
        case .append: childCoordinators.append(coordinator)
        }

        bag <~ coordinator.stepper.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()

        coordinator.start()
    }

    typealias Animated = Bool
    typealias DismissModalFlow = (Animated) -> Void
    func presentModalCoordinator<C>(
        makeCoordinator: (UINavigationController) -> C,
        navigationHandler: @escaping (C.Step, DismissModalFlow) -> Void
        ) where C: AnyCoordinator & Navigatable {

        let navigationController = UINavigationController()
        let coordinator = makeCoordinator(navigationController)

        log.verbose("\(self) presents \(coordinator)")

        childCoordinators.append(coordinator)
        coordinator.start()
        presenter.present(navigationController, animated: true, completion: nil)

        bag <~ coordinator.stepper.navigation.do(onNext: { [unowned self, unowned navigationController, unowned coordinator] navigationStep in
            navigationHandler(navigationStep, { animated in
                navigationController.dismiss(animated: animated, completion: nil)
                self.remove(childCoordinator: coordinator)
            })
        }).drive()

    }
}
