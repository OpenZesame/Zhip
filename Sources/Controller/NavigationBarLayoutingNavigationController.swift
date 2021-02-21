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

// Stolen from: https://stackoverflow.com/a/46895818/1311272
public final class NavigationBarLayoutingNavigationController: UINavigationController {

    public var lastLayout: NavigationBarLayout?

    // MARK: - Overridden Methods
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyLayoutToViewController(topViewController)
        interactivePopGestureRecognizer?.delegate = self
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        applyLayoutToViewController(viewController)
        super.pushViewController(viewController, animated: animated)
    }

    public override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        applyLayoutToViewController(viewControllerToPresent)
        super.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    @discardableResult
    public override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        applyLayoutToViewController(topViewController)
        return viewController
    }

    @discardableResult
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let result = super.popToViewController(viewController, animated: animated)
        applyLayoutToViewController(viewController)
        return result
    }

    @discardableResult
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let result = super.popToRootViewController(animated: animated)
        applyLayoutToViewController(topViewController)
        return result
    }
}

// MARK: - Public Methods
public extension NavigationBarLayoutingNavigationController {

    func applyLayoutToViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController, let barLayoutOwner = viewController as? NavigationBarLayoutOwner else { return }
        applyLayout(barLayoutOwner.navigationBarLayout)
    }

    func applyLayout(_ layout: NavigationBarLayout) {
        lastLayout = navigationBar.applyLayout(layout)
        let isHidden = layout.visibility.isHidden
        let animated = layout.visibility.animated
        setNavigationBarHidden(isHidden, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate Methods
extension NavigationBarLayoutingNavigationController: UIGestureRecognizerDelegate {}
public extension NavigationBarLayoutingNavigationController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
