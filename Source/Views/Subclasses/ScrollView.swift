//
//  ScrollViewOwner.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

private typealias € = L10n.View.PullToRefreshControl

// MARK: - ScrollView
class ScrollView: UIScrollView {

    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    // MARK: Overrideable
    func setup() { /* subclass me */ }
}

// MARK: - Private
private extension ScrollView {
    func privateSetup() {
        setupContentView()
        contentInsetAdjustmentBehavior = .never
        if self is PullToRefreshCapable {
            setupRefreshControl()
        }
        setup()
    }

    func setupContentView() {
        let contentView = makeView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.heightToSuperview()
        contentView.widthToSuperview()
        contentView.edgesToSuperview()
    }

    func makeView() -> UIView {
        guard let viewProvider = self as? ContentViewProvider else { incorrectImplementation("should conform to `ContentViewProvider`") }
        return viewProvider.makeContentView()
    }

    func setupRefreshControl() {
        alwaysBounceVertical = true
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.attributedTitle = NSAttributedString(string: €.title)
        self.refreshControl = refreshControl
    }
}

// MARK: - Rx
extension Reactive where Base: ScrollingStackView, Base: PullToRefreshCapable {
    var isRefreshing: Binder<Bool> {
        return base.refreshControl!.rx.isRefreshing
    }

    var pullToRefreshTrigger: Driver<Void> {
        return base.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriverOnErrorReturnEmpty()
    }
}
