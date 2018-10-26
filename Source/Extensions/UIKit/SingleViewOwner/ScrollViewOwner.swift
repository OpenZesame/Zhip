//
//  ScrollViewOwner.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

typealias ScrollingStackView = ScrollView & StackViewStyling

class ScrollView: UIScrollView {

    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    // Subclass me
    func setup() {}

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension ScrollView {
    func privateSetup() {
        setupContentView()
        contentInsetAdjustmentBehavior = .never
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
        guard let viewProvider = self as? ContentViewProvider else { fatalError("should conform to `ContentViewProvider`") }
        return viewProvider.makeContentView()
    }
}
