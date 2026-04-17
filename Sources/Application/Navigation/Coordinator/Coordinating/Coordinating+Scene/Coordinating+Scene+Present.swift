// MIT License — Copyright (c) 2018-2026 Open Zesame

import UIKit

typealias Completion = () -> Void
typealias DismissScene = (_ animatedDismiss: Bool, _ presentationCompletion: Completion?) -> Void

extension Coordinating {
    func modallyPresent<S: Scene<V>, V: ContentView>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        presentationCompletion: Completion? = nil,
        navigationHandler: @escaping NavigationHandlerModalScene<V.ViewModel>
    ) where V.ViewModel: Navigating {
        let scene = S(viewModel: viewModel)
        modallyPresent(
            scene: scene,
            animated: animated,
            presentationCompletion: presentationCompletion,
            navigationHandler: navigationHandler
        )
    }

    func modallyPresent<V: ContentView>(
        scene: some Scene<V>,
        animated: Bool = true,
        presentationCompletion: Completion? = nil,
        navigationHandler: @escaping NavigationHandlerModalScene<V.ViewModel>
    ) where V.ViewModel: Navigating {
        let viewModel = scene.viewModel
        let viewControllerToPresent = NavigationBarLayoutingNavigationController(rootViewController: scene)
        navigationController.present(viewControllerToPresent, animated: animated, completion: presentationCompletion)

        bag <~ viewModel.navigator.navigation
            .do(onNext: {
                navigationHandler($0) { [unowned scene] animated, navigationCompletion in
                    scene.dismiss(animated: animated, completion: navigationCompletion)
                }
            })
            .drive()
    }
}
