//
//  Presenting.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol Presenting: AnyObject {

    var presenter: Presenter? { get }
    var bag: DisposeBag { get }

    func present<P>(_ presentable: P, presentation: PresentationMode, navigationHandler: @escaping (P.Step) -> Void) where P: Presentable & Navigatable

    // swiftlint:disable:next function_parameter_count
    func present<S, V>(
        type: S.Type,
        viewModel: V.ViewModel,
        presentation: PresentationMode,
        configureNavigationItem: ((UINavigationItem) -> Void)?,
        navigationHandler: @escaping (V.ViewModel.Step) -> Void
    ) where V: UIView & ViewModelled, V.ViewModel: Navigatable, S: Scene<V>
}

// MARK: - Default Implementation
extension Presenting {
    func present<P>(_ presentable: P, presentation: PresentationMode = .animatedPush, navigationHandler: @escaping (P.Step) -> Void) where P: Presentable & Navigatable {
        _present(presentable, presentation: presentation, navigation: presentable.stepper.navigation, navigationHandler: navigationHandler)
    }

    func present<S, V>(
        type: S.Type,
        viewModel: V.ViewModel,
        presentation: PresentationMode = .animatedPush,
        configureNavigationItem: ((UINavigationItem) -> Void)? = nil,
        navigationHandler: @escaping (V.ViewModel.Step) -> Void
    ) where V: UIView & ViewModelled, V.ViewModel: Navigatable, S: Scene<V> {
        let scene = S.init(viewModel: viewModel)
        configureNavigationItem?(scene.navigationItem)
        _present(scene, presentation: presentation, navigation: viewModel.stepper.navigation, navigationHandler: navigationHandler)
    }
}

// MARK: - Private
private extension Presenting {
    func _present<P, Step>(_ presentable: P, presentation: PresentationMode = .animatedPush, navigation: Driver<Step>, navigationHandler: @escaping (Step) -> Void) where P: Presentable {
        presenter?.present(presentable, presentation: presentation)
        navigation.do(onNext: {
            navigationHandler($0)
        })
            .drive()
            .disposed(by: bag)
    }
}
