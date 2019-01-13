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

class AbstractSceneView: UIView, ScrollingStackView {

    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    lazy var scrollView = UIScrollView(frame: .zero)
    lazy var scrollViewContentView: UIStackView = makScrollViewContentView()
    private lazy var refreshControlCustomView = RefreshControlCustomView()
    lazy var refreshControl = UIRefreshControl()

    func makScrollViewContentView() -> UIStackView {
        guard let stackViewProvider = self as? StackViewStyling else {
            incorrectImplementation("Self should be StackViewStyling")
        }
        guard let stackView = stackViewProvider.makeContentView() as? UIStackView else {
            incorrectImplementation("ContentView should have been `UIStackView`")
        }
        return stackView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshControlCustomView.frame = refreshControl.bounds
    }


    // MARK: Overrideable
    func setup() { /* subclass me */ }

    func setRefreshControlTitle(_ title: String) {
        refreshControlCustomView.setTitle(title)
    }
}


// MARK: - Private
private extension AbstractSceneView {
    func privateSetup() {
        addSubview(scrollView)

        scrollView.addSubview(scrollViewContentView)
        scrollView.edgesToSuperview()

        scrollViewContentView.widthToSuperview()

        scrollViewContentView.edgesToParent(topToSafeArea: false, bottomToSafeArea: true)
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
        setup()
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

// Keyboard avoiding
extension AbstractSceneView {
//
//    private func registerNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        contentInset.bottom = convert(keyboardFrame.cgRectValue, from: nil).size.height
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        contentInset.bottom = 0
//    }
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
