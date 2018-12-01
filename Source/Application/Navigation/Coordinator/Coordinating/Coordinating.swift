//
//  Coordinating.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

/// Base protocol for any Coordinator. The coordinator is responsible for the navigation logic in the app.
/// Since it has no `associatedtype` we can use it as the element for a `childCoordinators` array, which contains
/// all the children of any coordinator.
///
/// ### References
/// [Coordinators Redux] By Khanlou (2015)
///
/// [Coordinators Redux]:
/// http://khanlou.com/2015/10/coordinators-redux/
///
protocol Coordinating: AnyObject, CustomStringConvertible {

    /// Coordinator stack, any child Coordinator should be appended to new array in order to retain it and handle its life cycle.
    var childCoordinators: [Coordinating] { get set }

    var bag: DisposeBag { get }

    /// This method is invoked by parent coodinator when this coordinator has been retained and presented.
    func start(didStart: Completion?)

    /// The NavigationController responsible for retaining and presenting Scenes (`UIViewController`s).
    var navigationController: UINavigationController { get }
}

extension Coordinating {
    var description: String {
        return stringRepresentation(level: 1)
    }
}
