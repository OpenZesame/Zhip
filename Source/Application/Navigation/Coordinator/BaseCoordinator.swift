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
import RxCocoa
import RxSwift

/// Base class for our coordinators.
class BaseCoordinator<NavigationStep>: Coordinating, Navigating {

    /// Coordinator stack, any child Coordinator should be appended to new array in order to retain it and handle its life cycle.
    var childCoordinators = [Coordinating]()

    /// The coordinators navigator is used for navigation logic between coordinators. A child coordinator could possible finish
    /// with to different navigation steps. The parent will then handle this logic and coordinate the next navigation step.
    let navigator = Navigator<NavigationStep>()

    /// Dispose bag used for disposing of Disposables from navigation subscription of child coordinators navigation.
    let bag = DisposeBag()

    let navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Overridable

    /// Method to be overriden by coordinator implementations. This method is invoked by parent coodinator when this
    /// coordinator has been retained and presented.
    func start(didStart: Completion? = nil) { abstract }
}
