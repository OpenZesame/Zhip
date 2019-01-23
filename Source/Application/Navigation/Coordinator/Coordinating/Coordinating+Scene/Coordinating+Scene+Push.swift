//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Presentation
extension Coordinating {

    /// This method is used to push a new Scene (ViewController).
    ///
    /// - Parameters:
    ///   - scene: Type of `Scene` (UIViewController) to present.
    ///   - viewModel: An instance of the ViewModel used by the `Scene`s View.
    ///   - animated: Whether to animate the presentation of the scene or not.
    ///   - navigationPresentationCompletion: Optional closure invoked when the
    ///       presentation of the scene is done (animation has finished). This
    ///       is convenient when you want to present any other scene after this
    ///       scene.
    ///   - navigationHandler: **Required** closure for handling navigation steps
    ///       from the ViewModel.
    ///   - step: Navigation step emitted by the scene's `viewModel`
    func push<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationPresentationCompletion: Completion? = nil,
        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigating {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        // Present the viewController
        navigationController.setRootViewControllerIfEmptyElsePush(
            viewController: scene,
            animated: animated,
            completion: navigationPresentationCompletion
        )

        // Subscribe to the navigation steps emitted by the viewModel's navigator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ viewModel.navigator.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()
    }
}

private extension UINavigationController {
    func setRootViewControllerIfEmptyElsePush(
        viewController: UIViewController,
        animated: Bool,
        completion: Completion? = nil
        ) {

        if viewControllers.isEmpty {
            setViewControllers([viewController], animated: false)
        } else {
            pushViewController(viewController, animated: animated)
        }

        // Add extra functionality to pass a "completion" closure even for `push`ed ViewControllers.
        guard let completion = completion else { return }
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
