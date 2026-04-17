// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

/// Base class for our coordinators.
class BaseCoordinator<NavigationStep>: Coordinating, Navigating {
    var childCoordinators = [Coordinating]()
    let navigator = Navigator<NavigationStep>()
    var cancellables = Set<AnyCancellable>()
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(didStart _: Completion? = nil) {
        abstract
    }
}
