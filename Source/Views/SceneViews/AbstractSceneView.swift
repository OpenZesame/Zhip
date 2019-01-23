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
import RxCocoa

class AbstractSceneView: UIView, ScrollViewOwner {

    lazy var refreshControl = RefreshControl()

    let scrollView: UIScrollView

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: .zero)
        setupAbstractSceneView()
    }

    func setupScrollViewConstraints() {
        scrollView.edgesToSuperview()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    // MARK: Overrideable

    /// Override this method from you scene views, setting up its subviews.
    func setup() { /* override me */ }
}

// MARK: - Private
private extension AbstractSceneView {
    // Due to classes and inheritance we cannot name this `setupSuviews`, since the subclasses cannot use that name.
    func setupAbstractSceneView() {
        defer { setup() }

        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        setupScrollViewConstraints()

        if self is PullToRefreshCapable {
            scrollView.contentInsetAdjustmentBehavior = .always
            setupRefreshControl()
        } else {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }

    func setupRefreshControl() {
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
    }
}

// MARK: - Rx
extension Reactive where Base: AbstractSceneView, Base: PullToRefreshCapable {
    var isRefreshing: Binder<Bool> {
        let refreshControl = base.refreshControl
        return refreshControl.rx.isRefreshing
    }

    var pullToRefreshTitle: Binder<String> {
        return Binder<String>(base) {
            $0.refreshControl.setTitle($1)
        }
    }

    var pullToRefreshTrigger: Driver<Void> {
        return base.refreshControl.rx.controlEvent(.valueChanged)
            .asDriverOnErrorReturnEmpty()
    }
}
