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
typealias Animated = Bool
typealias DismissModalFlow = (Animated) -> Void

extension BaseCoordinator {

    /// Starts a child coordinator which might be part of a flow of mutiple coordinators.
    /// Use this method when you know that you will finish the root coordinator at some
    /// point, which also will finish this new child coordinator.
    ///
    /// If you intend to start a single temporary coordinator that you will finish from
    /// the parent (the coordinator instance you called this method on) then please use
    /// `presentModalCoordinator` instead.
    ///
    /// - Parameters:
    ///   - coordinator: Child coordinator to start, either a perpertual coordinator or part of
    ///       a flow which root coordonator will finish.
    ///   - transition: Whether to replace replace the childCoordinator array with this the new
    ///       child coordinator or if it should be appended.
    ///   - didStart: Optional closure in which you can pass logic to be executed when the new child coordinator
    ///       has finished presentation of its root ViewController. In most cases this is not needed.
    ///   - navigationHandler: **Required** closure in which you should handle all navigation steps emitted by
    ///       the new child coordinator.
    func start<C>(
        coordinator child: C,
        transition: CoordinatorTransition = .append,
        didStart: CoordinatorDidStart? = nil,
        navigationHandler: @escaping (C.NavigationStep) -> Void
        ) where C: AnyCoordinator & Navigatable {

        // Add the child coordinator to the childCoordinator array
        switch transition {
        case .replace: childCoordinators = [child]
        case .append: childCoordinators.append(child)
        }

        // Subscribe to the navigation steps emitted by the child coordinator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ child.navigator.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()

        // Start the child coordinator (which is responsible for setting up its root UIViewController and presenting it)
        // and pass along the `didStart` closure, which the child should invoke or delegate to invoke.
        child.start(didStart: didStart)
    }

    /// Starts a new temporary flow with a new Coordinator.
    ///
    /// "Temporary" meaning that it's expected that the new coordinator (the "child")
    /// is expected to finish and when it finishes the calling coordinator (the "parent")
    /// will remove it from its `childCoordinator` collection.
    ///
    /// The child coordinator initialized by the parent call-site, in the `makeCoordinator` closure.
    /// This function initializes a new `UINavigationController` that is passed into the
    /// by the `makeCoordinator` closure as an argument.
    ///
    /// Optionally the parent can pass a `didStart` closure which will be invoked with the child
    /// coordinator has finished presenting its first ViewController.
    ///
    /// The `navigationHandler` closure is mandatory and should contain navigation logic where the
    /// parent handles each `NavigationStep` emitted by the child. Said `NavigationStep` is the first
    /// argument of the `navigationHandler` closure, the second argument being a closure the parent
    /// **should** call when it finishes this temporary flow. It is this call that removes the child
    /// coordinator from the parents `childCoordinator` array and also dismisses navigation stack.
    ///
    /// - Parameters:
    ///   - makeCoordinator: **Required** closure in which you should initialize the new child coordinator using the
    ///       `UINavigationController` being created by this function, passed as an argument in the closure.
    ///   - didStart: Optional Closure in which you can pass logic to be executed when the new child coordinator
    ///       has finished presentation of its root ViewController. In most cases this is not needed.
    ///   - navigationHandler: **Required** closure in which you should handle all navigation steps emitted by the
    ///       new child coordinator. This closure has two arguments, the first being the navigation step and the second
    ///       being a closure you **should** call when you want to end this temporary flow, which dismisses the navigation
    ///       stack and removes the child coordinator from its parent (the coordinator instance you called this method on).
    func presentModalCoordinator<C>(
        makeCoordinator: (UINavigationController) -> C,
        didStart: CoordinatorDidStart? = nil,
        navigationHandler: @escaping (C.NavigationStep, DismissModalFlow) -> Void
        ) where C: AnyCoordinator & Navigatable {

        // Initialize a new NavigationController to be passed to the new child coordinator
        let newModalNavigationController = UINavigationController()

        // Initialize the new child coordinator, by invoking the `makeCoordinator` closure,
        // passing the newly created NavigationController
        let child = makeCoordinator(newModalNavigationController)

        log.verbose("\(self) presents \(child)")

        // Add the child coordinator to the parents arrray of childen.
        childCoordinators.append(child)

        // Start the child coordinator (which is responsible for setting up its root UIViewController and presenting it)
        // and pass along the `didStart` closure, which the child should invoke or delegate to invoke.
        child.start(didStart: didStart)

        // Present the new NavigationController. The child coordinator is responsible for presenting its own root ViewController
        navigationController.present(newModalNavigationController, animated: true, completion: nil)

        // Subscribe to the navigation steps emitted by the child coordinator
        // And invoke the `navigationHandler` closure passed in to this method.
        // When invoking the `navigationHandler` besides passing the `navigationStep`
        // from the `child.navigator` we also pass a trailing closure, the `DismissModalFlow`
        // closure, which the parent coordinator _SHOULD_ invoke when it wants to finish this
        // temporary child coordinator.
        bag <~ child.navigator.navigation.do(onNext: { [unowned self, unowned newModalNavigationController, unowned child] navigationStep in
            navigationHandler(navigationStep, { animated in
                // Clean up navigation stack
                newModalNavigationController.dismiss(animated: animated, completion: nil)
                // Clean up coordinator stack
                self.remove(childCoordinator: child)
            })
        }).drive()

    }
}
