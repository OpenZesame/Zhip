//
//  CellConfigurable.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    associatedtype Model
    func configure(model: Model)
}
