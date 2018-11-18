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
    private(set) var presenter: UINavigationController?

    lazy var navigation = stepper.navigation

    // MARK: - Initialization
    init(presenter: UINavigationController?) {
        self.presenter = presenter
    }

    // MARK: - Overridable
    func start() { abstract }
}

// MARK: - Start Child Coordinator
extension BaseCoordinator {

    func start<C>(
        coordinator: C,
        transition: CoordinatorTransition = .append,
        shouldStartCoordinator: Bool = true,
        navigationHandler: @escaping (C.Step) -> Void
    ) where C: AnyCoordinator & Navigatable {

        switch transition {
        case .replace: childCoordinators = [coordinator]
        case .append: childCoordinators.append(coordinator)
        case .doNothing: break
        }

        coordinator.stepper.navigation.do(onNext: {
            navigationHandler($0)
        })
            .drive()
            .disposed(by: bag)

        if shouldStartCoordinator {
            coordinator.start()
        }
    }


    typealias Animated = Bool
    typealias DismissModalFlow = (Animated) -> Void
    func presentModalCoordinator<C>(
        makeCoordinator: (UINavigationController) -> C,
        navigationHandler: @escaping (C.Step, DismissModalFlow) -> Void
        ) where C: AnyCoordinator & Navigatable {

        let navigationController = UINavigationController()

        let coordinator = makeCoordinator(navigationController)
        coordinator.start()

        guard let presenter = presenter else { incorrectImplementation("Should have a presenter") }

        let dismissModalFlow: DismissModalFlow = { [unowned self] animated in
            navigationController.dismiss(animated: animated, completion: nil)
            self.remove(childCoordinator: coordinator)
        }

        presenter.present(viewController: navigationController, presentation: .present(animated: true, completion: { [unowned self] in
            self.start(coordinator: coordinator, transition: .append, shouldStartCoordinator: false) {
                navigationHandler($0, dismissModalFlow)
            }
        }))
    }
}
