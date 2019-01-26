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
