//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
