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
    func present<S, V>(
        scene: S.Type,
        viewModel: V.ViewModel,
        presentation: PresentationMode = .animatedPush,
        configureNavigationItem: ((UINavigationItem) -> Void)? = nil,
        navigationHandler: @escaping (V.ViewModel.Step) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigatable {

        let scene = S.init(viewModel: viewModel)
        configureNavigationItem?(scene.navigationItem)

        presenter?.present(viewController: scene, presentation: presentation)

        viewModel.stepper.navigation.do(onNext: {
            navigationHandler($0)
        }).drive().disposed(by: bag)
    }
}
