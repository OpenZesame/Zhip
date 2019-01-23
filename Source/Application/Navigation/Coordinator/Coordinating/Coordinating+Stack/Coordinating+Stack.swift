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

extension Coordinating {

    func firstIndexOf(child: Coordinating) -> Int? {
        return childCoordinators.firstIndex(where: { $0 === child })
    }

    func remove(childCoordinator child: Coordinating) {
        guard let index = firstIndexOf(child: child) else {
            incorrectImplementation("Should and must be able to find child coordinator and remove it in order to avoid memory leaks.")
        }
        childCoordinators.remove(at: index)

        guard firstIndexOf(child: child) == nil else {
            incorrectImplementation("Child coordinators should not contain the instance of `\(child)` after it have been removed")
        }
    }

    var topMostCoordinator: Coordinating {
        guard let last = childCoordinators.last else { return self }
        return last.topMostCoordinator
    }

    var topMostScene: AbstractController? {
        if let presentedController = topMostCoordinator.navigationController.presentedViewController {
            if let presentedNavigationController = presentedController as? UINavigationController {
                return presentedNavigationController.topViewController as? AbstractController
            } else {
                return presentedController as? AbstractController
            }
        } else {
            return topMostCoordinator.navigationController.topViewController as? AbstractController
        }
    }
}
