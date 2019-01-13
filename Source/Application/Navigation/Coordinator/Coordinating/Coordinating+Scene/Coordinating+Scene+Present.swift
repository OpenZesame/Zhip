//
//  BaseCoordinator+Scene+Present.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
