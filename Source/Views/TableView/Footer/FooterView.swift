//
//  FooterView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class FooterView: UITableViewHeaderFooterView {

    private lazy var label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

extension FooterView {
    func updateLabel(text: String) {
        label.text = text
    }
}

private extension FooterView {
    func setup() {
        label.withStyle(.init(textAlignment: .center, textColor: .silverGrey, font: .hint))

        contentView.addSubview(label)
        label.edgesToSuperview()
    }
}

