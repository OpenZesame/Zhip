//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

typealias SettingsItem = NavigatingCellModel<SettingsViewModel.NavigationStep>

protocol CellModel {
    var labelStyle: UILabel.Style { get }
    var imageViewStyle: UIImageView.Style { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}

struct NavigatingCellModel<Destination> {

    let destination: Destination
    let accessoryType: UITableViewCell.AccessoryType

    private let title: String
    private let icon: UIImage?
    private let style: Style

    fileprivate init(title: String, icon: UIImage?, destination: Destination, style: Style, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.title = title
        self.icon = icon
        self.destination = destination
        self.style = style
        self.accessoryType = accessoryType
    }
}

extension NavigatingCellModel: CellModel {
    var labelStyle: UILabel.Style {
        var labelStyle = style.labelStyle
        labelStyle.text = title
        return labelStyle
    }

    var imageViewStyle: UIImageView.Style {
        var imageViewStyle: UIImageView.Style = .default
        imageViewStyle.image = icon
        imageViewStyle.tintColor = style.iconTintColor
        return imageViewStyle
    }
}

extension NavigatingCellModel {
    enum Style {
        case normal, destructive
    }
}

extension NavigatingCellModel.Style {
    var labelStyle: UILabel.Style {
        switch self {
        case .normal, .destructive: return .body
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .normal: return .teal
        case .destructive: return .bloodRed
        }
    }
}

extension NavigatingCellModel {
    static func whenSelectedNavigate(
        to destination: Destination,
        titled title: String,
        icon: UIImage?,
        style: Style = .normal,
        accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    ) -> NavigatingCellModel {
        return NavigatingCellModel(title: title, icon: icon, destination: destination, style: style, accessoryType: accessoryType)
    }

    static func whenSelectedNavigate(
        to destination: Destination,
        titled title: String,
        icon: ImageAsset,
        style: Style = .normal,
        accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
        ) -> NavigatingCellModel {
        return whenSelectedNavigate(to: destination, titled: title, icon: icon.image, style: style, accessoryType: accessoryType)
    }
}

