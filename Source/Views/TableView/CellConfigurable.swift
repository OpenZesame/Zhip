//
//  CellConfigurable.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    associatedtype Model
    func configure(model: Model)
}

extension CellConfigurable where Self: UITableViewCell, Model: CellModel {
    func configure(model: Model) {
        guard let label = textLabel, let imageView = imageView else {
            incorrectImplementation("Should have label and imageView")
        }
        label.withStyle(model.labelStyle)
        imageView.withStyle(model.imageViewStyle)
        accessoryType = model.accessoryType
    }
}
