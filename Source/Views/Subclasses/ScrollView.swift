//
//  ScrollViewOwner.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa


protocol ContentViewProvider {
    func makeContentView() -> UIView
}

protocol StackViewStyling: ContentViewProvider {
    var stackViewStyle: UIStackView.Style { get }
}

extension ContentViewProvider where Self: StackViewStyling {
    func makeContentView() -> UIView {
        return UIStackView(frame: .zero).withStyle(stackViewStyle)
    }
}

protocol ScrollViewOwner {
    var scrollView: UIScrollView { get }
    associatedtype ScrollViewContentView: UIView
    var scrollViewContentView: ScrollViewContentView { get }
}

//UIView & ScrollViewOwner & StackViewStyling
protocol ScrollingStackView: ScrollViewOwner where ScrollViewContentView == UIStackView {}

extension ScrollingStackView where ScrollViewContentView == UIStackView {
    var stackView: UIStackView {
        return scrollViewContentView
    }
}

private typealias € = L10n.View.PullToRefreshControl

typealias BaseSceneView = AbstractSceneView & StackViewStyling

class AbstractSceneView: UIView, ScrollViewOwner {

    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    lazy var scrollView = UIScrollView(frame: .zero)
    lazy var scrollViewContentView: UIView = makScrollViewContentView()
    private lazy var refreshControlCustomView = RefreshControlCustomView()
    lazy var refreshControl = UIRefreshControl()

    func makScrollViewContentView() -> UIView {
        guard let contentViewProvider = self as? ContentViewProvider else {
            incorrectImplementation("Self should be ContentViewProvider")
        }
//        guard let stackView = stackViewProvider.makeContentView() as? UIStackView else {
//            incorrectImplementation("ContentView should have been `UIStackView`")
//        }
        return contentViewProvider.makeContentView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshControlCustomView.frame = refreshControl.bounds
    }


    // MARK: Overrideable
    func preSetup() { /* override me */ }
    func setup() { /* override me */ }

    func setRefreshControlTitle(_ title: String) {
        refreshControlCustomView.setTitle(title)
    }

    func setupScrollViewConstraints() {
        scrollView.edgesToSuperview()
    }
}


// MARK: - Private
private extension AbstractSceneView {
    func privateSetup() {

        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false

        preSetup()
        defer { setup() }

        addSubview(scrollView)
        setupScrollViewConstraints()

        scrollView.addSubview(scrollViewContentView)

        scrollViewContentView.widthToSuperview()
        scrollViewContentView.heightToSuperview(relation: .equalOrGreater, priority: .defaultHigh)
        scrollViewContentView.edgesToParent(topToSafeArea: false, bottomToSafeArea: (self is PullToRefreshCapable))

//        scrollViewContentView.leadingToSuperview()
//        scrollViewContentView.trailingToSuperview()
//        scrollViewContentView.topToSuperview(usingSafeArea: false)
//        scrollViewContentView.bottomToSuperview(relation: .equalOrLess, priority: .required, usingSafeArea: false)

        if self is PullToRefreshCapable {
            scrollView.contentInsetAdjustmentBehavior = .always
            setupRefreshControl()
        } else {
            scrollView.contentInsetAdjustmentBehavior = .never
//               scrollViewContentView.edgesToParent()
        }
    }


    func setupRefreshControl() {
        scrollView.alwaysBounceVertical = true
        refreshControl.tintColor = .clear // hiding bundled spinner
        scrollView.refreshControl = refreshControl
        refreshControl.addSubview(refreshControlCustomView)
//        refreshControlCustomView.frame = CGRect(x: 0, y: 0, width: refreshControl.frame.width, height: refreshControl.frame.height)
        setRefreshControlTitle(€.title)
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
