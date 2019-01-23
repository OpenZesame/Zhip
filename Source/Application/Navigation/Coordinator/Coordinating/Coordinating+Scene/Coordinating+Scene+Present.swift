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

// MARK: Modally present
typealias Completion = () -> Void
typealias DismissScene = (_ animatedDismiss: Bool, _ presentationCompletion: Completion?) -> Void

extension Coordinating {
    /// This method is used to modally present a Scene.
    ///
    /// - Parameters:
    ///   - scene: Type of `Scene` (UIViewController) to present.
    ///   - viewModel: An instance of the ViewModel used by the `Scene`s View.
    ///   - animated: Whether to animate the presentation of the scene or not.
    ///   - navigationHandler: **Required** closure handling the navigation steps emitted by the scene's ViewModel.
    ///   - step: The navigation steps emitted by the `viewmodel`
    ///   - dismiss: Closure you **should** invoke when you want to dimiss the scene.
    func modallyPresent<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep, _ dismiss: DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigating {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        // Create a new `UINavigationController` having the scene as root ViewController.
        // Since this is starting a new modal flow we should use a new NavigationController.
        let viewControllerToPresent = NavigationBarLayoutingNavigationController(rootViewController: scene)

        navigationController.present(viewControllerToPresent, animated: true, completion: nil)

        // Subscribe to the navigation steps emitted by the viewModel's navigator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ viewModel.navigator.navigation.do(onNext: {
            navigationHandler($0, { [unowned scene] animated, navigationCompletion in
                scene.dismiss(animated: animated, completion: navigationCompletion)
            })
        }).drive()
    }
}
