//
//  TableViewCell.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

class TableViewCell<Model: CellModel>: UITableViewCell, CellConfigurable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        selectionStyle = .default
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}
