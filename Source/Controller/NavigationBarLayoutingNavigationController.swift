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
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
