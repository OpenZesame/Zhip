//
//  RefreshControlCustomView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class RefreshControlCustomView: UIView {
    private lazy var spinner = SpinnerView()
    private lazy var label = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [spinner, label])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension RefreshControlCustomView {
    func setTitle(_ title: String) {
        label.text = title
    }
}

private extension RefreshControlCustomView {
    func setup() {
        backgroundColor = .clear
        contentMode = .scaleToFill
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.withStyle(.init(textAlignment: .center, textColor: .white, font: .title))
        stackView.withStyle(.vertical) {
            $0.distribution(.fill).spacing(0)
        }
        addSubview(stackView)
        stackView.edgesToSuperview()
        spinner.startSpinning()
//        spinner.height(30)
    }
}
