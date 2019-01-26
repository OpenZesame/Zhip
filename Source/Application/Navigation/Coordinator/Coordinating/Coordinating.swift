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
