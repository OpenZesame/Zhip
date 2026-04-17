// MIT License — Copyright (c) 2018-2026 Open Zesame

import UIKit

extension Coordinating {
    func push<S: Scene<V>, V: ContentView>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationPresentationCompletion: Completion? = nil,
        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep) -> Void
    ) where V.ViewModel: Navigating {
        let scene = S(viewModel: viewModel)
        pushSceneInstance(
            scene,
            animated: animated,
            navigationPresentationCompletion: navigationPresentationCompletion,
            navigationHandler: navigationHandler
        )
    }

    func pushSceneInstance<V: ContentView>(
        _ scene: some Scene<V>,
        animated: Bool = true,
        navigationPresentationCompletion: Completion? = nil,
        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep) -> Void
    ) where V.ViewModel: Navigating {
        let viewModel = scene.viewModel

        navigationController.setRootViewControllerIfEmptyElsePush(
            viewController: scene,
            animated: animated,
            completion: navigationPresentationCompletion
        )

        bag <~ viewModel.navigator.navigation
            .do(onNext: { navigationHandler($0) })
            .drive()
    }
}
