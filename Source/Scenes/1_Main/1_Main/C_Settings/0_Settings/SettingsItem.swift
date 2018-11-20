//
//  SettingsItem.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

struct SettingsItem {

    typealias Destination = SettingsViewModel.Step
    let title: String
    let destination: Destination
    let style: Style
    fileprivate init(title: String, destination: Destination, style: Style) {
        self.title = title
        self.destination = destination
        self.style = style
    }
}

extension SettingsItem {
    struct Style {
        let textColor: UIColor
    }
}

extension SettingsItem.Style {
    static var `default`: SettingsItem.Style {
        return SettingsItem.Style(textColor: .black)
    }

    static var destructive: SettingsItem.Style {
        return SettingsItem.Style(textColor: .red)
    }
}

extension SettingsItem {
    static func whenSelectedNavigate(to destination: Destination, titled title: String, style: Style = .default) -> SettingsItem {
        return SettingsItem(title: title, destination: destination, style: style)
    }
}
