//
//  PresentingCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol PresentingCoordinator: Coordinator, Navigator {
    var presenter: Presenter { get }
    func present<S, V>(scene: S.Type, makeViewModel: (Self) -> S.View.ViewModel) where S: Scene<V>
    
}
extension PresentingCoordinator {

    func present(_ presentable: Presentable, presentation: PresentationMode = .animatedPush) {
        presenter.present(presentable, presentation: presentation)
    }

    func present<S, V>(scene: S.Type, makeViewModel: (Self) -> S.View.ViewModel) where S: Scene<V> {
        let viewModel = makeViewModel(self)
        let scene = S.init(viewModel: viewModel)
        presenter.present(scene, presentation: .animatedPush)
    }

    func present<S, V>(scene: S.Type, makeViewModel: ((S.ViewModel.Type) -> (Self) -> S.View.ViewModel)) where S: Scene<V> {
        let viewModel = makeViewModel(S.ViewModel.self)(self)
        let scene = S.init(viewModel: viewModel)
        presenter.present(scene, presentation: .animatedPush)
    }
}
