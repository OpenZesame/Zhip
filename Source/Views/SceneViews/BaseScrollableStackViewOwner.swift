//
//  ScrollViewOwner.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshControlCustomView.frame = refreshControl.bounds
    }
}

private extension BaseScrollableStackViewOwner {
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
