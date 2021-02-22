// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

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
        didStart: Completion? = nil,
        navigationHandler: @escaping (_ step: C.NavigationStep) -> Void
        ) where C: Coordinating & Navigating {

        // Start the child coordinator (which is responsible for setting up its root UIViewController and presenting it)
        // and pass along the `didStart` closure, which the child should invoke or delegate to invoke.
        let startChild = { [unowned child] in
            child.start(didStart: didStart)
        }

        // Add the child coordinator to the childCoordinator array
        switch transition {
        case .replace:
            childCoordinators = [child]
            navigationController.removeAllViewControllers { startChild() }
        case .append:
            childCoordinators.append(child)
            startChild()
        }

        // Subscribe to the navigation steps emitted by the child coordinator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ child.navigator.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()
    }
}

extension UINavigationController {
    fileprivate func removeAllViewControllers(animated: Bool = true, completion: @escaping Completion) {
        func removeAllViewControllers() {
            if !viewControllers.isEmpty {
                viewControllers = []
            }
            DispatchQueue.main.async { completion() }
        }

        if let presented = presentedViewController {
            presented.dismiss(animated: animated) {
                removeAllViewControllers()
            }
        } else {
            removeAllViewControllers()
        }
    }
}
