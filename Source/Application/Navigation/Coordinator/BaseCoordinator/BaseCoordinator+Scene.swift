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

extension BaseCoordinator {

    func push<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationHandler h: @escaping (V.ViewModel.Step, DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        let scene = S.init(viewModel: viewModel)

        startDismissable(
            viewController: scene,
            navigation: viewModel.stepper.navigation,
            presentation: .setRootIfEmptyElsePush(animated: animated),
            navigationHandler: h
        )
    }

    func modallyPresent<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        configureNavigationItem: ((UINavigationItem) -> Void)? = nil,
        navigationHandler h: @escaping (V.ViewModel.Step, DismissScene) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        let scene = S.init(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: scene)

        startDismissable(
            viewController: navigationController,
            navigation: viewModel.stepper.navigation,
            presentation: .present(animated: true, completion: nil),
            configureNavigationItem: configureNavigationItem,
            navigationHandler: h)
    }
}

private extension BaseCoordinator {

    func startDismissable<NavigationStep>(
        viewController: UIViewController,
        navigation: Driver<NavigationStep>,
        presentation: PresentationMode,
        configureNavigationItem: ((UINavigationItem) -> Void)? = nil,
        navigationHandler: @escaping (NavigationStep, DismissScene) -> Void
        ) {

        guard let presenter = presenter else { incorrectImplementation("Should have a navigationController") }

        configureNavigationItem?(viewController.navigationItem)

        presenter.present(viewController: viewController, presentation: presentation)

        navigation.do(onNext: {
            navigationHandler($0, { [unowned viewController] animated in
                viewController.dismiss(animated: animated, completion: nil)
            })
        }).drive().disposed(by: bag)
    }
}

typealias PresentationCompletion = () -> Void
typealias IsAnimated = Bool
typealias DismissScene = (IsAnimated) -> Void

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
