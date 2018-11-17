//
//  Navigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol AbstractCoordinator: AnyObject, BaseNavigatable {
    func start()
    var bag: DisposeBag { get }
    var childCoordinators: [AbstractCoordinator] { get set }
    func start<C>(coordinator: C, transition: CoordinatorTransition, navigationHandler: @escaping (C.Step) -> Void) where C: Coordinator & Navigatable
}

extension AbstractCoordinator {
    func anyCoordinatorOf<C>(type: C.Type) -> C? where C: AbstractCoordinator {
        guard let coordinator = childCoordinators.compactMap({ $0 as? C }).first else {
            log.error("Coordinator has no child coordinator of type: `\(String(describing: type))`")
            return nil
        }
        return coordinator
    }

    func remove(childCoordinator: AbstractCoordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

protocol Coordinator: AbstractCoordinator, Navigatable, Presenting {}


extension AbstractCoordinator {

    func start<C>(coordinator: C, transition: CoordinatorTransition = .append, navigationHandler: @escaping (C.Step) -> Void) where C: AbstractCoordinator & Navigatable {
        switch transition {
        case .replace: childCoordinators = [coordinator]
        case .append: childCoordinators.append(coordinator)
        case .doNothing: break
        }

        coordinator.stepper.navigation.do(onNext: {
            navigationHandler($0)
        })
            .drive()
            .disposed(by: bag)

        coordinator.start()
    }
}

enum CoordinatorTransition {
    case append
    case replace
    case doNothing
}

