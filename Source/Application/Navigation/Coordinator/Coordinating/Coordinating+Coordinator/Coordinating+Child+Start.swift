//
//  Coordinating+Child+Start.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Coordinating {

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
    ///   - step: The navigation step emitted by this new child coordinator. Handled by `navigationHandler` in this parent coordinator.
    func start<C>(
        coordinator child: C,
        transition: CoordinatorTransition = .append,
        didStart: (() -> Void)? = nil,
        navigationHandler: @escaping (_ step: C.NavigationStep) -> Void
        ) where C: Coordinating & Navigating {

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
}
