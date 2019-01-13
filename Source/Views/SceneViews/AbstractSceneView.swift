//
//  AbstractSceneView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AbstractSceneView: UIView, ScrollViewOwner {

    lazy var refreshControlCustomView = RefreshControlCustomView()
    lazy var refreshControl = UIRefreshControl()

    let scrollView: UIScrollView

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: .zero)
        setupAbstractSceneView()
    }

    func setRefreshControlTitle(_ title: String) {
        refreshControlCustomView.setTitle(title)
    }

    func setupScrollViewConstraints() {
        scrollView.edgesToSuperview()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    // MARK: Overrideable
    func setup() { /* override me */ }
}

// MARK: - Private
private extension AbstractSceneView {
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
        refreshControl.tintColor = .clear // hiding bundled spinner
        scrollView.refreshControl = refreshControl
        refreshControl.addSubview(refreshControlCustomView)
        setRefreshControlTitle(L10n.View.PullToRefreshControl.title)
    }
}

// MARK: - Rx
extension Reactive where Base: AbstractSceneView, Base: PullToRefreshCapable {
    var isRefreshing: Binder<Bool> {
        return base.refreshControl.rx.isRefreshing
    }

    var pullToRefreshTitle: Binder<String> {
        return Binder<String>(base) {
            $0.setRefreshControlTitle($1)
        }
    }

    var pullToRefreshTrigger: Driver<Void> {
        return base.refreshControl.rx.controlEvent(.valueChanged)
            .asDriverOnErrorReturnEmpty()
    }
}
