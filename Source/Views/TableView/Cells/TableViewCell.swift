//
//  TableViewCell.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

class AbstractTableViewCell: UITableViewCell {

    fileprivate lazy var customLabel = UILabel()
    fileprivate lazy var customImageView = UIImageView()
    fileprivate lazy var stackView = UIStackView(arrangedSubviews: [customImageView, customLabel])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

private extension AbstractTableViewCell {
    func setup() {
        backgroundColor = .clear
        selectionStyle = .default

        // Note that we should call `customLabel.withStyle(model.labelStyle)`
        // and `customImageView.withStyle(model.imageViewStyle)` inside `configure:model`
        stackView.withStyle(.horizontal) {
            $0.distribution(.fillProportionally)
                .layoutMargins(UIEdgeInsets(vertical: 0, horizontal: 16))
        }

        contentView.addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.height(56)
    }
}

class TableViewCell<Model: CellModel>: AbstractTableViewCell, CellConfigurable {}

extension CellConfigurable where Self: AbstractTableViewCell, Model: CellModel {
    func configure(model: Model) {
        customLabel.withStyle(model.labelStyle)
        customImageView.withStyle(model.imageViewStyle)
        accessoryType = model.accessoryType
    }
}
