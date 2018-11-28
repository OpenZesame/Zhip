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

class BaseCoordinator<NavigationStep>: AnyCoordinator, Navigatable {

    var childCoordinators = [AnyCoordinator]()

    let navigator = Navigator<NavigationStep>()
    let bag = DisposeBag()
    private(set) var navigationController: UINavigationController

    lazy var navigation = navigator.navigation

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Overridable
    func start(didStart: CoordinatorDidStart? = nil) { abstract }

    deinit {
        log.verbose("💣 \(String(describing: self))")
    }
}

// MARK: - Start Child Coordinator
typealias CoordinatorDidStart = () -> Void
extension BaseCoordinator {

    func start<C>(
        coordinator: C,
        transition: CoordinatorTransition = .append,
        didStart: CoordinatorDidStart? = nil,
        navigationHandler: @escaping (C.NavigationStep) -> Void
        ) where C: AnyCoordinator & Navigatable {

        switch transition {
        case .replace: childCoordinators = [coordinator]
        case .append: childCoordinators.append(coordinator)
        }

        bag <~ coordinator.navigator.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()

        coordinator.start(didStart: didStart)
    }

    typealias Animated = Bool
    typealias DismissModalFlow = (Animated) -> Void
    func presentModalCoordinator<C>(
        makeCoordinator: (UINavigationController) -> C,
        didStart: CoordinatorDidStart? = nil,
        navigationHandler: @escaping (C.NavigationStep, DismissModalFlow) -> Void
        ) where C: AnyCoordinator & Navigatable {

        let newModalNavigationController = UINavigationController()
        let coordinator = makeCoordinator(newModalNavigationController)

        log.verbose("\(self) presents \(coordinator)")

        childCoordinators.append(coordinator)
        coordinator.start(didStart: didStart)
        self.navigationController.present(newModalNavigationController, animated: true, completion: nil)

        bag <~ coordinator.navigator.navigation.do(onNext: { [unowned newModalNavigationController, unowned coordinator] navigationStep in
            navigationHandler(navigationStep, { animated in
                newModalNavigationController.dismiss(animated: animated, completion: nil)
                self.remove(childCoordinator: coordinator)
            })
        }).drive()

    }
}
