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

    var navigationController: UINavigationController { get }
    var bag: DisposeBag { get }

    func present<P>(_ presentable: P, presentation: PresentationMode, navigationHandler: @escaping (P.Step) -> Void) where P: Presentable & Navigatable

    func present<V>(type: Scene<V>.Type, viewModel: V.ViewModel, presentation: PresentationMode, navigationHandler: @escaping (V.ViewModel.Step) -> Void) where V: UIView & ViewModelled, V.ViewModel: Navigatable
}

// MARK: - Default Implementation
extension Presenting {
    func present<P>(_ presentable: P, presentation: PresentationMode = .animatedPush, navigationHandler: @escaping (P.Step) -> Void) where P: Presentable & Navigatable {
        _present(presentable, presentation: presentation, navigation: presentable.navigation, navigationHandler: navigationHandler)
    }

    func present<V>(type: Scene<V>.Type, viewModel: V.ViewModel, presentation: PresentationMode = .animatedPush, navigationHandler: @escaping (V.ViewModel.Step) -> Void) where V: UIView & ViewModelled, V.ViewModel: Navigatable
    {
        let scene = Scene<V>.init(viewModel: viewModel)
        _present(scene, presentation: presentation, navigation: viewModel.navigation, navigationHandler: navigationHandler)
    }
}

// MARK: - Private
private extension Presenting {
    func _present<P, Step>(_ presentable: P, presentation: PresentationMode = .animatedPush, navigation: Driver<Step>, navigationHandler: @escaping (Step) -> Void) where P: Presentable {
        navigationController.present(presentable, presentation: presentation)
        navigation.do(onNext: {
            navigationHandler($0)
        })
            .drive()
            .disposed(by: bag)
    }
}