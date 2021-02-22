// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
