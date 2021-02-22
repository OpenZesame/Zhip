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
import RxSwift
import RxCocoa

// MARK: Modally present
typealias Completion = () -> Void
typealias DismissScene = (_ animatedDismiss: Bool, _ presentationCompletion: Completion?) -> Void

extension Coordinating {
    /// This method is used to modally present a Scene.
    ///
    /// Identical to modallyPresent:scene:animated:navigationPresentationCompletion:navigationHandler
    /// But takes a viewModel instance instead of a scene instance and a Scene type instead of an instance of said scene type.
    func modallyPresent<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        presentationCompletion: Completion? = nil,
//        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep, _ dismiss: @escaping DismissScene) -> Void
        navigationHandler: @escaping NavigationHandlerModalScene<V.ViewModel>
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigating {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        modallyPresent(
            scene: scene,
            animated: animated,
            presentationCompletion: presentationCompletion,
            navigationHandler: navigationHandler
        )
    }

    /// This method is used to modally present a Scene.
    ///
    /// - Parameters:
    ///   - scene: A `Scene` (UIViewController) to present.
    ///   - animated: Whether to animate the presentation of the scene or not.
    ///   - navigationHandler: **Required** closure handling the navigation steps emitted by the scene's ViewModel.
    func modallyPresent<S, V>(
        scene: S,
        animated: Bool = true,
        presentationCompletion: Completion? = nil,
//        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep, _ dismiss: @escaping DismissScene) -> Void
        navigationHandler: @escaping NavigationHandlerModalScene<V.ViewModel>
    ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigating {

        let viewModel = scene.viewModel

        // Create a new `UINavigationController` having the scene as root ViewController.
        // Since this is starting a new modal flow we should use a new NavigationController.
        let viewControllerToPresent = NavigationBarLayoutingNavigationController(rootViewController: scene)

        navigationController.present(viewControllerToPresent, animated: animated, completion: presentationCompletion)

        // Subscribe to the navigation steps emitted by the viewModel's navigator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ viewModel.navigator.navigation.do(onNext: {
            navigationHandler($0, { [unowned scene] animated, navigationCompletion in
                scene.dismiss(animated: animated, completion: navigationCompletion)
            })
        }).drive()
    }
}
