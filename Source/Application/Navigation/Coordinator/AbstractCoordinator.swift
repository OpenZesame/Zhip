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

class BaseCoordinator<Step>: Coordinator {

    var childCoordinators = [AbstractCoordinator]()
    let stepper = Stepper<Step>()
    let bag = DisposeBag()
    private(set) var presenter: Presenter?

    lazy var navigation = stepper.navigation

    // MARK: - Initialization
    init(presenter: Presenter?) {
        self.presenter = presenter
    }

    // MARK: - Overridable
    func start() { abstract }
}

extension BaseCoordinator {
    typealias Animated = Bool
    typealias DismissModalFlow = (Animated) -> Void

    func presentModalCoordinator<C>(
        makeCoordinator: (UINavigationController) -> C,
        navigationHandler: @escaping (C.Step, DismissModalFlow) -> Void
        ) where C: AbstractCoordinator & Navigatable {

        let navigationController = UINavigationController()

        let coordinator = makeCoordinator(navigationController)

        presentModal(coordinator: coordinator, navigationController: navigationController, navigationHandler: navigationHandler)
    }

}

// MARK: - Private
private extension BaseCoordinator {
    func presentModal<C>(
        coordinator: C,
        navigationController: UINavigationController,
        navigationHandler: @escaping (C.Step, DismissModalFlow) -> Void
        ) where C: AbstractCoordinator & Navigatable {

        guard let presenter = presenter else { incorrectImplementation("Should have a presenter") }

        let dismissModalFlow: DismissModalFlow = { [unowned self] animated in
            navigationController.dismiss(animated: animated, completion: nil)
            self.remove(childCoordinator: coordinator)
        }

        presenter.present(navigationController, presentation: .present(animated: true, completion: { [unowned self] in
            self.start(coordinator: coordinator, transition: .append) {
                navigationHandler($0, dismissModalFlow)
            }
        }))
    }
}
