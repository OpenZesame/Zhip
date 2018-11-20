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

    func push<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationHandler: @escaping (V.ViewModel.Step, DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        let scene = S.init(viewModel: viewModel)

        startDismissable(
            viewController: scene,
            navigation: viewModel.stepper.navigation,
            presentation: .setRootIfEmptyElsePush(animated: animated),
            navigationHandler: navigationHandler
        )
    }

    /// This method is used to modally present a Scene. In all most all cases
    /// you should NOT pass a custom `navigationController` to this method, but rather
    /// pass `nil` which will use this coordinators navigationController, the only time
    /// you should pass a navigationController is if you which be able to push the scene
    /// on the topmost navigationContorller, e.g. when locking the app with
    /// pincode.
    func modallyPresent<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationController customNavigationController: UINavigationController? = nil,
        navigationHandler: @escaping (V.ViewModel.Step, DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        let scene = S.init(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: scene)

        startDismissable(
            viewController: navigationController,
            navigation: viewModel.stepper.navigation,
            presentation: .present(animated: true, completion: nil),
            navigationController: customNavigationController,
            navigationHandler: navigationHandler
        )
    }
}

private extension BaseCoordinator {

    func startDismissable<NavigationStep>(
        viewController: UIViewController,
        navigation: Driver<NavigationStep>,
        presentation: PresentationMode,
        navigationController customNavigationController: UINavigationController? = nil,
        navigationHandler: @escaping (NavigationStep, DismissScene) -> Void
        ) {

        (customNavigationController ?? navigationController).present(viewController: viewController, presentation: presentation)

        navigation.do(onNext: {
            navigationHandler($0, { [unowned viewController] animated, navigationCompletion in
                viewController.dismiss(animated: animated, completion: navigationCompletion)
            })
        }).drive().disposed(by: bag)
    }
}

typealias PresentationCompletion = () -> Void
typealias IsAnimated = Bool
typealias DismissScene = (IsAnimated, PresentationCompletion?) -> Void

private enum PresentationMode {
    case present(animated: Bool, completion: PresentationCompletion?)
    case setRootIfEmptyElsePush(animated: Bool)
}

extension UINavigationController {
    fileprivate func present(viewController: UIViewController, presentation: PresentationMode) {
        switch presentation {
        case .present(let animated, let completion): present(viewController, animated: animated, completion: completion)
        case .setRootIfEmptyElsePush(let animated):
            if viewControllers.isEmpty {
                viewControllers = [viewController]
            } else {
                pushViewController(viewController, animated: animated)
            }
        }
    }
}
