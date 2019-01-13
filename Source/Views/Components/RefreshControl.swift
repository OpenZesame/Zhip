//
//  RefreshControlCustomView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class RefreshControl: UIRefreshControl {
    private lazy var spinner = SpinnerView()
    private lazy var label = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [spinner, label])

    override init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    // Ugly hack to remove default spinner: https://stackoverflow.com/a/33472020/1311272
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        // setting `isHidden = true` does not work
        subviews.first?.alpha = 0
    }
}

extension RefreshControl {
    func setTitle(_ title: String) {
        label.text = title
    }
}

private extension RefreshControl {
    func setup() {
        backgroundColor = .clear
        contentMode = .scaleToFill
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.withStyle(.init(textAlignment: .center, textColor: .white, font: .title))
        stackView.withStyle(.vertical) {
            $0.distribution(.fill).spacing(0)
        }
        addSubview(stackView)
        spinner.height(30, priority: .defaultHigh)
        stackView.edgesToSuperview()
        spinner.startSpinning()
        setTitle(L10n.View.PullToRefreshControl.title)
    }
}
