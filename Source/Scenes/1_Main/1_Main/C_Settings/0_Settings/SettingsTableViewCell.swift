//
//  SettingsTableViewCell.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {}

extension SettingsTableViewCell: CellConfigurable {
    func configure(model: SettingsItem) {
        textLabel?.text = model.title
        textLabel?.textColor = model.style.textColor
        textLabel?.font = UIFont.Label.body
    }
}
