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

/// Base class for our coordinators.
class BaseCoordinator<NavigationStep>: Coordinating, Navigating {

    /// Coordinator stack, any child Coordinator should be appended to new array in order to retain it and handle its life cycle.
    var childCoordinators = [Coordinating]()

    /// The coordinators navigator is used for navigation logic between coordinators. A child coordinator could possible finish
    /// with to different navigation steps. The parent will then handle this logic and coordinate the next navigation step.
    let navigator = Navigator<NavigationStep>()

    /// Dispose bag used for disposing of Disposables from navigation subscription of child coordinators navigation.
    let bag = DisposeBag()

    let navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        log.verbose("💣 \(type(of: self))")
    }

    // MARK: - Overridable

    /// Method to be overriden by coordinator implementations. This method is invoked by parent coodinator when this
    /// coordinator has been retained and presented.
    func start(didStart: Completion? = nil) { abstract }
}
