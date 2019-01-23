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

typealias ScrollableStackViewOwner = BaseScrollableStackViewOwner & StackViewStyling

class BaseScrollableStackViewOwner: AbstractSceneView {

    // MARK: Initialization
    init() {
        super.init(scrollView: UIScrollView(frame: .zero))
        setupBaseScrollableStackViewOwner()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    lazy var scrollViewContentView: UIView = makScrollViewContentView()

    func makScrollViewContentView() -> UIView {
        guard let contentViewProvider = self as? ContentViewProvider else {
            incorrectImplementation("Self should be ContentViewProvider")
        }
        return contentViewProvider.makeContentView()
    }
}

// MARK: - Private
private extension BaseScrollableStackViewOwner {
    // Due to classes and inheritance we cannot name this `setupSuviews`, since the subclasses cannot use that name.
    func setupBaseScrollableStackViewOwner() {
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(scrollViewContentView)

        scrollViewContentView.widthToSuperview()
        scrollViewContentView.heightToSuperview(relation: .equalOrGreater, priority: .defaultHigh)
        scrollViewContentView.edgesToParent(topToSafeArea: false, bottomToSafeArea: (self is PullToRefreshCapable))
    }
}

private extension UIView {
    func edgesToParent(topToSafeArea: Bool, bottomToSafeArea: Bool) {
        guard let superview = superview else { incorrectImplementation("Should have `superview`") }
        edgesTo(view: superview, topToSafeArea: topToSafeArea, bottomToSafeArea: bottomToSafeArea)
    }

    func edgesTo(view: UIView, topToSafeArea: Bool = true, bottomToSafeArea: Bool = true) {
        let topAnchor = topToSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let bottomAnchor = bottomToSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor

        [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: topAnchor),
            self.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}
