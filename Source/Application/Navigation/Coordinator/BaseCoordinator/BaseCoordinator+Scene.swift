//
//  BaseCoordinator+Scene.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Looking through the navigation stack
extension BaseCoordinator {
    func isTopmost<Scene>(scene: Scene.Type) -> Bool where Scene: UIViewController {
        guard navigationController.topViewController is Scene else { return false }
        return true
    }
}

// MARK: - Presentation
extension BaseCoordinator {

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
    ///       by the scenes ViewModel.
    func push<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationPresentationCompletion: PresentationCompletion? = nil,
        navigationHandler: @escaping (V.ViewModel.NavigationStep) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        // Delegate presentation and invoking of navigation handling to private method.
        startDismissable(
            viewController: scene,
            navigation: viewModel.navigator.navigation,
            presentation: .setRootIfEmptyElsePush(animated: animated),
            navigationPresentationCompletion: navigationPresentationCompletion,
            navigationHandler: { navigationStepFromViewModel, _ in
                navigationHandler(navigationStepFromViewModel)
            }
        )
    }

    /// This method is used to modally present a Scene.
    /// In almost all case you should **NOT** pass a `UINavigationController` instance to
    /// this method, but rather pass `nil` which will use this coordinator's own
    /// `navigationController`. The only time you should pass a navigationController is
    /// when you which be able to push the scene on the topmost navigationContorller, e.g.
    /// when locking the app with pincode.
    ///
    /// - Parameters:
    ///   - scene: Type of `Scene` (UIViewController) to present.
    ///   - viewModel: An instance of the ViewModel used by the `Scene`s View.
    ///   - animated: Whether to animate the presentation of the scene or not.
    ///   - customNavigationController: Optional instance of a `UINavigationController` that you would
    ///       like to present the scene on, instead of using the coordinators own
    ///       navigationController. **In most cases you should pass `nil`.**
    ///   - navigationHandler: **Required** closure handling the navigation steps emitted by the scenes ViewModel.
    ///       the first argument of the closure is the navigation steps emitted by the viewmodel, and
    ///       the second argument is a closure you **should** invoke when you want to dimiss the scene.
    func modallyPresent<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationController customNavigationController: UINavigationController? = nil,
        navigationHandler: @escaping (V.ViewModel.NavigationStep, DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        // Create a new `UINavigationController` having the scene as root ViewController.
        // Since this is starting a new modal flow we should use a new NavigationController.
        let navigationController = UINavigationController(rootViewController: scene)

        // Delegate presentation and invoking of navigation handling to private method.
        startDismissable(
            viewController: navigationController,
            navigation: viewModel.navigator.navigation,
            presentation: .present(animated: true),
            navigationController: customNavigationController,
            navigationHandler: navigationHandler
        )
    }
}

// MARK: - Private Methods
private extension BaseCoordinator {

    func startDismissable<NavigationStep>(
        viewController: UIViewController,
        navigation: Driver<NavigationStep>,
        presentation: PresentationMode,
        navigationController customNavigationController: UINavigationController? = nil,
        navigationPresentationCompletion: PresentationCompletion? = nil,
        navigationHandler: @escaping (NavigationStep, DismissScene) -> Void
        ) {

        // Present the viewController
        (customNavigationController ?? navigationController).present(viewController: viewController, presentation: presentation, completion: navigationPresentationCompletion)

        // Subscribe to the navigation steps emitted by the viewModel's navigator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ navigation.do(onNext: {
            navigationHandler($0, { [unowned viewController] animated, navigationCompletion in
                viewController.dismiss(animated: animated, completion: navigationCompletion)
            })
        }).drive()
    }
}

// MARK: Fileprivate NavigationController helpers
typealias PresentationCompletion = () -> Void
typealias IsAnimated = Bool
typealias DismissScene = (IsAnimated, PresentationCompletion?) -> Void

private enum PresentationMode {
    case present(animated: Bool)
    case setRootIfEmptyElsePush(animated: Bool)
}

extension UINavigationController {
    fileprivate func present(viewController: UIViewController, presentation: PresentationMode, completion: PresentationCompletion? = nil) {
        switch presentation {
        case .present(let animated): present(viewController, animated: animated, completion: completion)
        case .setRootIfEmptyElsePush(let animated):
            if viewControllers.isEmpty {
                viewControllers = [viewController]
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
}
